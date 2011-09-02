require 'hpricot'
require 'delegate'

module Topcgen
  class ProblemStatement < DelegateClass(Hash)
    def initialize html
      begin
        doc = Hpricot.parse html
        container = doc/'td.problemText'

        definition = (container/'tr').find { |tr| tr.inner_html.include? 'Class:' }/'table'
        class_definition = (definition/'tr').find { |tr| tr.inner_html.include? 'Class:' }
        method_definition = (definition/'tr').find { |tr| tr.inner_html.include? 'Method:' }
        parameters_definition = (definition/'tr').find { |tr| tr.inner_html.include? 'Parameters:' }
        returns_definition = (definition/'tr').find { |tr| tr.inner_html.include? 'Returns:' }
        signature_definition = (definition/'tr').find { |tr| tr.inner_html.include? 'Method signature:' }

        @data = {}
        @data[:class] = safe_html (class_definition/'td')[1].inner_html
        @data[:method] = safe_html (method_definition/'td')[1].inner_html
        @data[:parameters] = safe_html (parameters_definition/'td')[1].inner_html
        @data[:returns] = safe_html (returns_definition/'td')[1].inner_html
        @data[:signature] = safe_html (signature_definition/'td')[1].inner_html

        super(@data)
      rescue Exception => e
        $log.error 'ProblemStatement: parsing html failed'
        $log.error e.message
        $log.error e.backtrace.inspect
        $log.error html.strip() unless html.nil?
        raise e
      end
    end

    private

    def safe_html html
      html.strip 
    end
  end
end
