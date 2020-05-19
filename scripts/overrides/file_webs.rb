require "open-uri"
require "yaml"

class FileWebs

  def get_url_list
    urls = YAML.load_file(self.file_location)
    # there are two types of yaml files in the webs directory:
    # straightforward, paths with metadata
    # less straightforward, we need to build the metadata from a range
    if urls.key?("paths")
      urls["paths"] || []
    else
      raise "No paths found for webscraping in file #{self.file_location}"
    end
  end

  def read_html_content(url_item)
    # TODO does not use authentication for development site, instead relying on IP range
    puts "scraping path: #{url_item["path"]}"
    begin
      path = File.join(@options["site_url"], url_item["path"])
      raw = URI.open(path) { |f| f.read }
      Nokogiri::HTML(raw)
    rescue => e
      raise "something went wrong while scraping #{path}: #{e}"
    end
  end

  # overriding default behavior because instead of reading files in the webs directory
  # the URLs are provided by a YML file in source/webs
  def transform_es
    es_req = []
    urls = get_url_list

    begin
      urls.each do |url_item|
        file_xml = read_html_content(url_item)

        # the below code is nearly the same as the default transform_es, but the information from the YML
        # file is added to the options so that the identifier information can be populated

        # check if any xpaths hit before continuing
        results = file_xml.xpath(*subdoc_xpaths.keys)
        if results.length == 0
          raise "No possible xpaths found for file #{self.filename}, check if XML is valid or customize 'subdoc_xpaths' method"
        end
        subdoc_xpaths.each do |xpath, classname|
          subdocs = file_xml.xpath(xpath)
          subdocs.each do |subdoc|
            specific_options = @options.clone
            specific_options["webs"] = url_item
            file_transformer = classname.new(subdoc, specific_options, file_xml, self.filename(false))
            es_req << file_transformer.json
          end
        end
      end
      if @options["output"]
        filepath = "#{@out_es}/#{self.filename(false)}.json"
        File.open(filepath, "w") { |f| f.write(pretty_json(es_req)) }
      end
      return es_req
    rescue => e
      puts "something went wrong transforming #{self.filename}"
      puts e.backtrace
      raise e
    end
  end

  # commenting out because we don't need the webscraped content to be transformed to html
  # and we also don't need an error
  def transform_html
  end
end
