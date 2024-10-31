class TeiToEs < XmlToEs

  def override_xpaths
    {
      "person" => "/TEI/teiHeader/profileDesc/textClass/keywords[@n='people']/term",
      "publisher" => "//sourceDesc/msDesc/msIdentifier/repository"
    }
  end

  def cover_image
    img = get_list(@xpaths["image_id"]).first
    "#{img}.jpg"
  end

  def spatial
  end

  def category2
    #changing from array
    get_text(@xpaths["subcategory"])
  end

end
