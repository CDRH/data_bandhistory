#!/usr/bin/env ruby

# Image Authority Updater
#
# 2020 Jessica Dussault (jduss4)
#
# The images.csv file has better information
# than that of the authority CSVs, the latter
# of which are in the possession of UNL Archives
# & Special Collections.
# Therefore, this script combines images.csv back
# into the authority files and removes the originally
# overriding information in images.csv as it goes.

# This was written very quickly and will probably need
# work if you are going to be running it all the time

require "csv"

def read_csv(file_path)
  file_location = File.join(Dir.pwd, file_path)
  CSV.read(file_location, {
    encoding: "utf-8",
    headers: true,
    return_headers: true
  })
end

def write_csv(file_path, contents)
  file_location = File.join(Dir.pwd, file_path)
  File.open(file_location, "w") { |f| f.write(contents) }
end

images = read_csv("source/csv/images.csv")

authority_files = {
  "2029" => "2029-lentz.csv",
  "130815" => "rg130815.csv",
  "130833" => "rg130833.csv",
  "421201" => "rg421201.csv",
  "421202" => "rg421201.csv",
  "421203" => "rg421201.csv",
  "" => "other-collections-partial.csv"
}
auth_lookup = {}

authority_files.each do |code, file|
  csv = read_csv(File.join("source/authority", file))
  auth_lookup[code] = csv
end

images.each do |image|
  # don't need to check those donated to band project
  next if image["filename"].include?("band.img.")

  # if there are any non-keywords:
  #   locate in authority file
  #   replace in authority, remove from images
  if image["date"] || image["title"] || image["description"]
    type = image["filename"].split("-").first
    # for some reason, one UComm is in "other collections"
    if image["filename"] == "421202-pp6138"
      type = ""
    end
    # if no auth found, use other collections
    auth = auth_lookup[type] || auth_lookup[""]
    item = auth.find { |row| row["identifier/filename"] == image["filename"] }
    if item
      ["date", "title", "description"].each do |field|
        if image[field] && image[field].length > 0
          item[field] = image[field]
          image[field] = nil
        end
      end
    else
      puts "could not find entry for #{image["filename"]}"
    end
  end
end

write_csv("source/csv/images.csv", images)
auth_lookup.each do |code, csv|
  file = authority_files[code]
  write_csv(File.join("source/authority", file), csv)
end
