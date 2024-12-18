class TeiToEs < XmlToEs

  def override_xpaths
    {
      "person" => "/TEI/teiHeader/profileDesc/textClass/keywords[@n='people']/term",
      "collection" => "//sourceDesc/msDesc/msIdentifier/collection"
    }
  end

  ########################
  #    Field Builders    #
  ########################

  # TODO: the builders load several nested fields from source into has_source title to 
  # replicate v1 site functionality in v2, but this is a fairly objectionable use of 
  # has_source.title and might should be revisited at some point
  def array_to_string (array)
      return array.map { |i| i.to_s }.join(", ")
  end

  def build_has_source_title
    author = get_text(@xpaths["source"]["author"])
    title = get_text(@xpaths["source"]["title"])
    date = get_text(@xpaths["source"]["date"])
    collection = get_text(@xpaths["source"]["collection"])
    repository = get_text (@xpaths["source"]["repository"])

    array_build = Array.[]
    array_build << author if author
    array_build << title if title
    array_build << date if date
    array_build << collection if collection
    array_build << repository if repository

    return array_to_string(array_build)
  end

  ################
  #    FIELDS    #
  ################

  def cover_image
    img = get_list(@xpaths["image_id"]).first
    "#{img}.jpg"
  end

  def has_source
    {
      "title" => build_has_source_title
    }
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
