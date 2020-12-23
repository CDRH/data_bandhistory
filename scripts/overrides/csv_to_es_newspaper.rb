class CsvToEsNewspaper < CsvToEs

  def preprocessing
    person_csv = File.join(@options["collection_dir"], "source/authority/personography.csv")
    @personography = CSV.read(person_csv, {
      encoding: "utf-8",
      headers: true,
      skip_blanks: true,
      return_headers: true
    })
  end

  def get_id
    @row["Identifier"]
  end

  def category
    "Documents"
  end

  def date(before=true)
    Datura::Helpers.date_standardize(@row["Date"])
  end

  def description
    @row["Item Description"]
  end

  def keywords
    kw = @row["Subjects"]
    kw.split(/; ?/) if kw
  end

  def person
    news_per = @row["People"]
    if news_per && news_per != "-"
      people = []

      news_per.split(/; ?|\n/).each do |per|
        # try to confirm that this person is in the personography spreadsheet
        hit = @personography.find { |row| row["display name"] == per }
        if !hit
          puts "No personography entry found for #{per}"
          people << {
            name: per
          }
        else
          people << {
            id: hit["identifier"],
            name: hit["display name"],
            role: nil
            # technically we have a brief role written in the personography
            # file but it's not ready for game day
          }
        end
      end
      people
    end
  end

  def publisher
    @row["Collection Title"]
  end

  def rights_holder
    publisher
  end

  def source
    url = @row["Box, Folder, URL"]
    # trim search terms off of url
    url.split("#words").first if url
  end

  def subcategory
    "Newspaper"
  end

  def text_additional
    [
      title,
      date,
      description,
      publisher
    ]
  end

  def title
    @row["Title"]
  end

end
