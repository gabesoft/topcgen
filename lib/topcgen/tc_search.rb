require 'hpricot'

module Topcgen
  class TcSearch
    attr_accessor :links

    def initialize(html)
      doc = Hpricot html
      container = doc/"form[@name='problemListForm']"

      links = container/'a.statText'
      @links = links.find_all { |a| a.inner_html.include? 'details' }.map { |a| a.attributes['href'] }
    end

  end
end
