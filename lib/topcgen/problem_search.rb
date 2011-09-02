require 'hpricot'

module Topcgen
  class ProblemSearch
    attr_accessor :links

    def initialize(html)
      # TODO: centralize begin/rescue/end blocks for all problem parsers
      begin
        doc = Hpricot html
        container = doc/"form[@name='problemListForm']"

        links = container/'a.statText'
        @links = links.find_all { |a| a.inner_html.include? 'details' }.map { |a| a.attributes['href'] }
      rescue Exception => e
        $log.error 'ProblemSearch: parsing html failed'
        $log.error e.message
        $log.error e.backtrace.inspect
        $log.error html.strip() unless html.nil?
        raise e
      end
    end

  end
end
