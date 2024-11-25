class TeiToEs < XmlToEs

  def override_xpaths
    {
      "person" => "/TEI/teiHeader/profileDesc/textClass/keywords[@n='people']/term",
      "collection" => "//sourceDesc/msDesc/msIdentifier/collection"
    }
  end

  def cover_image
    img = get_list(@xpaths["image_id"]).first
    "#{img}.jpg"
  end

  def rights_uri
    get_text(@xpaths["collection"])
  end

  def spatial
  end

  def category2
    #changing from array
    get_text(@xpaths["subcategory"])
  end

end
