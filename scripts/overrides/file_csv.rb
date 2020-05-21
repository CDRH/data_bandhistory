require_relative "csv_to_es_film.rb"
require_relative "csv_to_es_image.rb"
require_relative "file_type_footage.rb"

class FileCsv < FileType
  include FileTypeFootage

  # overriding the initialization in order to read in
  # the supporting CSVs which provide more metadata
  # than is listed in the more general spreadsheet
  def initialize(file_location, options)
    super(file_location, options)
    @csv = read_csv(file_location, options["csv_encoding"])

    @mega_metadata = combine_archives_data
  end

  # overriding this in order to build reels + footage HTML at the moment
  # NOT used for images
  def build_html_from_csv
    if self.filename(false) == "footage"
      build_footage_reels_html
    else
      puts "HTML generation not supported for #{self.filename(false)}"
    end
  end

  def row_to_es(headers, row)
    if self.filename(false) == "images"
      row_to_es_image(headers, row)
    else
      row_to_es_footage(headers, row)
    end
  end

  protected

  # would like to combine each row of the csv in question
  # with its archival record, if one exists
  def combine_archives_data
    # read in all the spreadsheets in `source/archives` and create
    # a hash based on the identifiers
    archives_ids = {}
    get_archives_files.each do |file|
      archives_csv = read_csv(file, @options["csv_encoding"])
      archives_csv.each do |row|
        id = row["identifier/filename"]
        next if id == "identifier/filename" || id.nil?
        if archives_ids.key?(id)
          # TODO need to resolve these
          puts "ALREADY FOUND #{id}"
        end
        archives_ids[id] = row
      end
    end
    archives_ids
  end

  def get_archives_files
    archives_path = File.join(
      @options["collection_dir"],
      "source",
      "authority",
      "*.csv"
    )
    Dir[archives_path]
  end

  def remove_empty_columns(row)
    row.delete_if { |k,v| v.nil? || v.empty? || v == " " }
  end

  def row_to_es_footage(header, row)
    # look up the reel associated with this clip and add it to the CSV row
    reel_id = row["Archives Reel"]
    row["reel"] = @mega_metadata[reel_id]
    CsvToEsFilm.new(row, @options, @csv, self.filename(false)).json
  end

  def row_to_es_image(header, row)
    final_row = row
    matching_row = @mega_metadata[row["filename"]]
    if matching_row
      # remove all empty elements of row to avoid
      # overridding content with an empty thing
      clean_row = remove_empty_columns(row)
      final_row = matching_row.to_h.merge(clean_row)
    end
    CsvToEsImage.new(final_row, @options, @csv, self.filename(false)).json
  end

end
