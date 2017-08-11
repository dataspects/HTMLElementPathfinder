require 'rainbow'
require 'nokogiri'
require 'net/http'
require 'uri'
require 'awesome_print'
require 'json'

module DSC
  class HTMLElementPathfinder

    attr_reader :html_string, :path

    def initialize websites
      @websites = websites
      @elements_to_ignore = [
        'title', 'script'
      ]
    end

    def run
      @websites.each do |id, data|
        STDOUT.puts "\nFind '#{data[:text]}' in '#{data[:url]}':"
        if data[:method] == 'POST'
          @html_string = open_post(data[:url], data[:params])
        else
          @html_string = open_get(data[:url])
        end
        find_path_to_text(data[:text], data[:url])
        STDOUT.puts view_threaded_path
      end
    end

    def find_path_to_text text, url
      html = Nokogiri::HTML(@html_string)
      elements_found = html.xpath("//*[contains(text(), '#{text}')]")
      # TODO: MULTIPLES!
      if elements_found.empty?
        STDOUT.puts "#{text} not found in #{url}"
      else
        elements_found.each do |element|
          if consider_element?(element)
            initialize_path(element)
            get_parents_until_body_tag(element)
          end
        end
      end
    end

    def view_threaded_path
      if @path.nil?
        STDOUT.puts "@Path is empty!"
      else
        i = -1
        threaded_array = @path.reverse.map do |tag|
          i += 1
          classes = "class=\"#{Rainbow(tag[:attributes]['class']).bright}\""
          if tag[:attributes]['id']
            id = "id='#{tag[:attributes]['id']}' "
          end
          "#{"  " * i}#{Rainbow(tag[:name]).green} #{Rainbow(id).orange}#{Rainbow(classes).blue}"
        end
        return "#{threaded_array.join("\n")}"
      end
    end

    private

      def initialize_path element
        @path = [
          {
            name: element.name,
            attributes: element.attributes
          }
        ]
      end

      def consider_element? element
        if @elements_to_ignore.include?(element.name)
          return false
        else
          return true
        end
      end

      def open_get(url)
        Net::HTTP.get(URI.parse(url))
      end

      def open_post(url, params)
        Net::HTTP.post_form(
          URI.parse(url),
          eval(params)
        ).body
      end

      def get_parents_until_body_tag element
        @path << {
          name: element.parent.name,
          attributes: element.parent.attributes
        }
        unless element.parent.name == "body"
          get_parents_until_body_tag(element.parent)
        end
      end

  end
end

@hep = DSC::HTMLElementPathfinder.new(@websites)
@hep.run
