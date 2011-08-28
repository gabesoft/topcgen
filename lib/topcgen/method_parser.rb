require 'delegate'

module Topcgen
  class MethodParser
    attr_reader :name
    attr_reader :return_type
    attr_reader :parameters

    def initialize(name, parameter_types, return_type, signature)
      @name = name
      @return_type = return_type
      @parameter_types = parse_parameters parameter_types
      @parameters = parse_signature signature
    end

    private

    def parse_parameters parameters
      parameters.split(/,\s*/)
    end

    def parse_signature signature
      patt = /#{Regexp.quote(@return_type)}\s+#{Regexp.quote(name)}\((.+)\)/x
      parameters = patt.match(signature)[1].split(/,\s+/)
      parameters.zip(@parameter_types).map do |p_decl, p_type| 
        p_patt = /#{Regexp.quote(p_type)}\s+([a-zA-Z_]+)/x 
        { :name => p_patt.match(p_decl)[1], :type => p_type }
      end
    end
  end
end
