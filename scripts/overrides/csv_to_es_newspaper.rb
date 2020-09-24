class CsvToEsNewspaper < CsvToEs

  def get_id
    @row["Identifier"]
  end

  def category
    "Sights & Sounds"
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
    # TODO tie in personography file to get person id
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
