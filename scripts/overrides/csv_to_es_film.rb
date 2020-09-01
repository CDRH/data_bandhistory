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

  def format
    "Film Clip"
  end

  def image_id
    "website%2F#{row["ID"]}.jpg"
  end

  def keywords
    @row["Keywords"].split(/; ?/) if @row["Keywords"]
  end

  def publisher
    "Archives & Special Collections, University of Nebraska-Lincoln Libraries"
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

  def text_additional
    footage = [
      @row["Year Estimate"],
      @row["Description"],
      @row["Keywords"],
      @row["Sponsor"],
    ]
    if @row["reel"]
      reel = @row["reel"].to_h.values.join(" ")
      footage << reel
    end
    footage
  end

  def title
    "Footage from #{@row["Year Estimate"]}"
  end

  def uri_html
    # TODO temp override for local development
    "http://localhost:5000/output/development/html/#{@id}.html"
  end

end
