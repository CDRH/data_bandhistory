class TeiToEs < XmlToEs

  def override_xpaths
    {
      "person" => "/TEI/teiHeader/profileDesc/textClass/keywords[@n='people']/term",
      "publisher" => "//sourceDesc/msDesc/msIdentifier/repository"
    }
  end

  def image_id
    img = get_list(@xpaths["image_id"]).first
    "#{img}.jpg"
  end

  def spatial
  end

end
