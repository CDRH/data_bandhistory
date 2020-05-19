class WebsToEs < XmlToEs

  def get_id
    @options["webs"]["identifier"]
  end

  def override_xpaths
    {
      "date" => "//@data-date",
      "date_display" => "//*[@data-field='date_display']",
      "person" => "//*[@data-person]",
      "text" => "//div[@id='content-wrapper']",
      "titles" => "//h1",
    }
  end

  def category
    @options["webs"]["category"]
  end

  def date(before=true)
    d = get_text(@xpaths["date"])
    if d
      Datura::Helpers.date_standardize(d, before)
    end
  end

  def date_display
    get_text(@xpaths["date_display"])
  end

  def person
    # TODO eventually will need to look these up in the personography
    # so as to get the display name, but for now just allowing text
    # through as it appears
    all_p = @xml.xpath(@xpaths["person"])
    file_location = File.join(@options["collection_dir"], "source/authority/personography.csv")
    personography = CSV.read(file_location, {
      encoding: "utf-8",
      headers: true,
      return_headers: true
    })
    all_p = all_p.map do |p|
      id = p["data-person"]
      person_match = personography.find { |row| row["identifier"] == id }
      if person_match
        { id: id, name: person_match["display name"] }
      else
        puts "did not find person with id #{id}"
      end
    end
    all_p.uniq
  end

  def subcategory
    @options["webs"]["subcategory"]
  end

  def uri
    File.join(@options["site_url"], @options["webs"]["path"])
  end

  def uri_data
    base = @options["data_base"]
    subpath = "data/#{@options["collection"]}/source/webs"
    File.join(base, subpath, "#{@filename}.yml")
  end

end
