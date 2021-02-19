module CsvToEsArchiveRecord

  def date_parse(rec_date, before)
    return nil if !rec_date
    # the dates are coming through in a variety of formats
    # and ultimately we want them to be as close to YYYY-MM-DD as possible
    dt = rec_date.strip
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
      formatted = "19#{y}/#{m}/#{d}"

    # YYYY/(M)M/(D)D
    elsif dt[/^\d{4}\/\d{1,2}\/\d{1,2}$/]
      y, m, d = dt.split(/\/-/)
      formatted = "#{y}-#{m}-#{d}"

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
    formatted
  end

  def source_combine(row)
    # TODO standardize formatting of record group
    # if this is from archives, show src / box
    # otherwise just use collection
    src = row["source/RG#/MS#"]
    box = row["tablecontents/boxes/folders"]
    coll = row["isPartOf/Collection"]
    if src.nil? || src == "n/a"
      coll
    else
      "#{src} #{box}: #{coll}"
    end
  end

end
