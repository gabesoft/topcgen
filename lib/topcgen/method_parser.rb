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
      assert_same_length(@parameter_types, parameters)

      parameters.zip(@parameter_types).map do |p_decl, p_type| 
        p_patt = /#{Regexp.quote(p_type)}\s+([a-zA-Z_]+)/x 
        assert_same_type(p_decl, p_type, p_patt)
        { :name => p_patt.match(p_decl)[1], :type => p_type }
      end
    end

    def assert_same_length(s1, s2)
      raise "length mismatch: #{s1} vs #{s2}" if s1.length != s2.length
    end

    def assert_same_type(text, type, patt)
      raise "type mismatch: #{type} vs #{text}" if (text =~ patt) != 0
    end
  end
end
