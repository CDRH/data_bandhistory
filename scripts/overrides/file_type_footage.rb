# specific behavior for footage moved here
# to avoid cluttering up the FileCsv overrides

module FileTypeFootage

  @@footage_fields = [
    "ID",
    "Clip Seconds",
    "Year Estimate",
    "Description",
    "Archives Reel", 
    "Sponsor"
  ]

  @@reel_fields = {
    "identifier/filename" => "ID",
    "description" => "Reel Description",
    "date" => "Date",
    "medium/format/type" => "Format",
    "source/RG#/MS#" => "Record Group",
    "isPartOf/Collection" => "Collection",
    "creator/photographer" => "Creator",
    "rights" => "Rights"
  }

  def build_footage_reels_html
    # need to combine the reels with the relevant footage
    # and create a nice lil html page of them all
    @csv.each_with_index do |row, index|
      next if row.header_row?

      # TODO revisit and clean this up?
      reel_id = row["Archives Reel"]
      reel = @mega_metadata[reel_id]
      video_path = File.join(@options["media_base"], "video", @options["collection"], "footage", "#{row["ID"]}.mp4")
      img_path = File.join(@options["media_base"],
        "iiif/2", "bandhistory%2Ffootage%2F#{row["ID"]}.jpg", "full", "!500,500", "0/default.jpg")

      # using XML instead of HTML for simplicity's sake
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.div(class: "main_content") {
          xml.h1(row["Year"])
          xml.video(controls: "", preload: "none", poster: img_path) {
            xml.source(src: video_path, type: "video/mp4")
            xml.p("Your browser doesn't support HTML5 video. Here is a <a href=\"#{video_path}\">link to the video</a> instead")
          }
          xml.h2("Footage Clip Information")
          xml.ul {
            @@footage_fields.each do |header|
              xml.li {
                xml.strong(header)
                xml.text(": #{row[header]}")
              }
            end
          }
          xml.h2("Reel Information")
          xml.ul {
            @@reel_fields.each do |header, label|
              xml.li {
                xml.strong(label)
                xml.text(": #{reel[header]}")
              }
            end
            xml.li {
              xml.strong("Media Commons URL")
              xml.text(": ")
              xml.a(row["Media Commons URL"], href: row["Media Commons URL"])
            }
          }
        }
      end
      write_html_to_file(builder, row["ID"])
    end
  end

end
