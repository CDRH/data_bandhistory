require_relative "csv_to_es_archive_record"

class CsvToEsImage < CsvToEs
  include CsvToEsArchiveRecord

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
    formatted = date_parse(@row["date"], before)
    Datura::Helpers.date_standardize(formatted, before)
  end

  def date_display
    @row["date"]
  end

  def image_id
    "#{@id}.jpg"
  end

  def publisher
    @row["publisher"] || @row["publisher/repository"]
  end

  def rights_holder
    @row["publisher"] || @row["publisher/repository"]
  end

  def source
    source_combine(@row)
  end

  def person
    # TODO after encoding is completed
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
      date_display,
      @row["isPartOf/Collection"],
      @row["creator/photographer"],
      @row["contributor/collector"],
      @row["publisher/repository"]
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
