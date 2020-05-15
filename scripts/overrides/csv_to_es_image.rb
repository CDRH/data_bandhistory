class CsvToEsImage < CsvToEs

  def get_id
    @row["filename"]
  end

  def category
    "Sights & Sounds"
  end

  def creator
    all = @row["creator/photographer"]
    if all
      all.split(";").map do |pers|
        { name: pers }
      end
    end
  end

  def date(before=true)
    return nil if !@row["date"]
    # the dates are coming through in a variety of formats
    # and ultimately we want them to be as close to YYYY-MM-DD as possible
    dt = @row["date"].strip
    formatted = ""
    # YYYY
    if dt[/^\d{4}$/]
      formatted = dt

    # YYYY-YYYY
    elsif dt[/^\d{4}-\d{4}$/]
      y1, y2 = dt.split("-")
      formatted = before ? y1 : y2

    # (M)M/(D)D/YY  <- always assuming 20th century in this case
    elsif dt[/^\d{1,2}\/\d{1,2}\/\d{2}$/]
      d, m, y = dt.split(/\/-/)
      formatted = "#{d}/#{m}/19#{y}"

    # YYYY(,) September 8
    # YYYY, Sept.( 8)
    elsif dt[/^\d{4},? (\w*)\.?(?: (\d{1,2}))?$/]
      matches = dt.match(/^(\d{4}),? (\w*)\.? ?(\d{1,2})?$/)
      if matches
        y = matches[1]
        m = get_month_num(matches[2])
        d = matches[3]
        formatted = "#{y}-#{m}-#{d}"
      else
        puts "something went wrong processesing date #{dt}"
      end
    else
      # Undated / undated
      puts "missing #{dt}" if !dt[/[Uu]ndated|TODO/]
    end

    Datura::Helpers.date_standardize(formatted, before)
  end

  def subcategory
    row["subcategory"]
  end

  def description
    @row["description"]
  end

  def image_id
    "photographs%2F#{@id}.jpg"
  end

  def publisher
    @row["publisher"] || @row["publisher/repository"]
  end

  def rights
    @row["rights"]
  end

  def rights_holder
    @row["publisher"] || @row["publisher/repository"]
  end

  def source
    # TODO standardize formatting of record group
    # if this is from archives, show src / box
    # otherwise just use collection
    src = @row["source/RG#/MS#"]
    box = @row["tablecontents/boxes/folders"]
    coll = @row["isPartOf/Collection"]
    if src.nil? || src == "n/a"
      coll
    else
      "#{src} #{box}: #{coll}"
    end
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

  def subcategory
    "Images"
  end

  def text_additional
    [
      @row["title"],
      @row["description"],
      @row["subject/topic"],
      date,
      @row["creator/photographer"],
      @row["contributor/collector"]
    ]
  end

  def topics
    [ @row["topic"] ]
  end

  def uri_html
    nil
  end

  private

  def get_month_num(m_label)
    if m_label
      first_three = m_label[0,3]
      Date::ABBR_MONTHNAMES.index(first_three)
    end
  end

end
