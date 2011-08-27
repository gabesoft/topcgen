require 'hpricot'
require 'delegate'

module Topcgen
  class TcDetail < DelegateClass(Hash)
    attr_accessor :data

    def initialize(html)
      doc = Hpricot.parse(html)
      container = doc/'div.statTableIndent'

      stmt_link = (container/'a.statText').find { |a| a.attributes['href'].include? 'problem_statement' }
      round_link = (container/'a.statText').find { |a| a.attributes['href'].include? 'round_overview' }
      row_used_as = (container/'tr').find { |tr| tr.inner_html.include? 'Used As:' }
      row_categories = (container/'tr').find { |tr| tr.inner_html.include? 'Categories:' }
      row_point_value = (container/'tr').find { |tr| tr.inner_html.include? 'Point Value' }

      @data = {}
      @data[:name]            = safe_html stmt_link.inner_html
      @data[:statement_link]  = stmt_link.attributes['href']
      @data[:used_in]         = safe_html round_link.inner_html
      @data[:used_as]         = safe_html (row_used_as/'td')[1].inner_html
      @data[:categories]      = safe_html (row_categories/'td')[1].inner_html
      @data[:point_value]     = safe_html (row_point_value/'td')[1].inner_html

      super(@data)
    end

    private 

    def safe_html html
      html.strip 
    end
  end
end
