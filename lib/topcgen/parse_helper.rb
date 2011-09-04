require 'cgi'

module Topcgen
  class ParseHelper
    def self.find_deep(doc, element, *contains)
      continue = true
      container = (doc/element).find { |t| contains.all? { |s| t.inner_html.include? s } }

      temp = nil
      while continue
        temp = (container/element).find { |t| contains.all? { |s| t.inner_html.include? s } } 
        container = temp unless temp.nil?
        continue = !!temp
      end

      container
    end

    def self.escape html
      CGI.unescapeHTML html
    end

    def self.clean_ws html
      html.gsub(/\s+/, "")
    end

    def self.strip_ws html
      html.strip
    end

    def self.split (html, char)
      html.split(/#{char}\s*/).map { |e| strip_ws e }
    end
  end
end
