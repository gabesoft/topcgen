module Topcgen
  class ValueParser
    attr_reader :data

    def initialize(type, text)
      case type
      when 'String'
        @data = parse_string text
      when 'int'
        @data = parse_int text
      when 'long'
        @data = parse_long text
      when 'String[]'
        @data = parse_string_array text
      when 'int[]'
        @data = parse_int_array text
      when 'long[]'
        @data = parse_long_array text
      else
        raise "unknown type #{type}"
      end
    end

    def parse_string text
      text
    end

    def parse_int text
      Integer text
    end

    def parse_long text
      Integer text.gsub("L", "")
    end

    def parse_string_array text
      # TODO: implement
    end

    def parse_int_array text
      # TODO: implement
    end

    def parse_long_array text
      # TODO: implement
    end
  end
end
