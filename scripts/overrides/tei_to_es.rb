class TeiToEs < XmlToEs

  def image_id
    img = get_list(@xpaths["image_id"]).first
    "#{img}.jpg"
  end

  def spatial
  end

end
