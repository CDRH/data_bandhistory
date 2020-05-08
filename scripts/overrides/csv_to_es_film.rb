class CsvToEsFilm < CsvToEs

  def get_id
    @row["ID"]
  end

  def category
    "Sights & Sounds"
  end

  def subcategory
    "Footage"
  end

  def date(before=true)
    datestr = @row["Year Estimate"]
    Datura::Helpers.date_standardize(datestr, before)
  end

  def description
    @row["Description"]
  end

  def image_id
    # TODO will have to customize for thumbnail preview pic
    "#{@id}.jpg"
  end

  def keywords
    @row["Keywords"].split(/; ?/) if @row["Keywords"]
  end

  def publisher
    "University of Nebraska Archives and Special Collections"
  end

  def source
    @row["Archives Reel"]
  end

  def person
    # TODO not sure any of the videos really have closeups or anything
    # of particular band directors, but presumably we could tag them
    # if we wanted to
    # TODO definitely SHOULD include Neihardt with his full label
    # from his own project, in order to show up in CDRH search results
  end

end
