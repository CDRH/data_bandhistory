class CsvToEs

  def get_id
    @row["filename"]
  end

  def description
    @row["description"]
  end

  def image_id
    # TODO will need full IIIF path
    "#{@id}.jpg"
  end

  def publisher
    # TODO
    "Sort of probably Archives?"
  end

  def source
    # TODO
    "This one we can fill out!"
  end

  def person
    # TODO ideally we will pull this into a field I guess
    # if it's something that matters to us, for now just
    # pulling some important names out
    notable_persons = []
    ["Snider", "Lentz", "Pershing", "Quick"].each do |item|
      if @row["title"] && @row["title"].include?(item)
        notable_persons << { "name" => item }
      elsif @row["description"] && @row["description"].include?(item)
        notable_persons << { "name" => item }
      end
    end
    notable_persons
  end

end
