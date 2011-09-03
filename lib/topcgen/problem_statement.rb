require 'hpricot'
require 'delegate'

module Topcgen

  class ProblemStatement < DelegateClass(Hash)
    attr_reader :tests

    def initialize html
      doc = Hpricot.parse html
      container = ParseHelper.find_deep(doc, 'table', 'Class:', 'Method:', 'Returns:')

      class_definition = (container/'tr').find { |tr| tr.inner_html.include? 'Class:' }
      method_definition = (container/'tr').find { |tr| tr.inner_html.include? 'Method:' }
      parameters_definition = (container/'tr').find { |tr| tr.inner_html.include? 'Parameters:' }
      returns_definition = (container/'tr').find { |tr| tr.inner_html.include? 'Returns:' }
      signature_definition = (container/'tr').find { |tr| tr.inner_html.include? 'Method signature:' }

      @data = {}
      @data[:class]       = ParseHelper.strip_ws (class_definition/'td')[1].inner_html
      @data[:method]      = ParseHelper.strip_ws (method_definition/'td')[1].inner_html
      @data[:parameters]  = ParseHelper.strip_ws (parameters_definition/'td')[1].inner_html
      @data[:returns]     = ParseHelper.strip_ws (returns_definition/'td')[1].inner_html
      @data[:signature]   = ParseHelper.strip_ws (signature_definition/'td')[1].inner_html

      super(@data)

      @tests = parse_tests doc
    rescue
      raise ParseException.new html
    end

    private

    def parse_tests doc
      [] # TODO: implement
    end
  end
end
