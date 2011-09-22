module Topcgen
  class ValueParser
    attr_reader :match
    attr_reader :match_length

    def initialize type
      @type = type
    end

    def parse text
      case @type
      when 'String'
        parse_string text
      when 'int'
        parse_int text
      when 'long'
        parse_long text
      when 'double'
        parse_double text
      when 'String[]'
        parse_string_array text
      when 'int[]'
        parse_int_array text
      when 'long[]'
        parse_long_array text
      when 'double[]'
        parse_double_array text
      else
        raise "don't know how to parse values of type #{@type}"
      end
    rescue
      raise ValueParseException.new(@type, text)
    end

    def self.parse(types, values)
      input = values.clone()
      types.map do |t|
        parser = ValueParser.new t
        parser.parse input
        input.slice!(0..parser.match_length - 1)
        parser.match
      end
    rescue ValueParseException
      raise ParseException.new "#{values}, types were #{types}"
    end

    private

    def parse_string text
      parse_text(/^"([^"]+?)?"(,\s*)?/x, text)
    end

    def parse_int text
      parse_text(/^([+\-0-9]+)(,\s*)?/x, text)
      @match = Integer @match
    end

    def parse_long text
      parse_text(/^([+\-0-9]+)(L?,\s*)?/x, text)
      @match = Integer @match
    end

    def parse_double text
      parse_text(/^([+\-0-9.]+)(,\s*)?/x, text)
      @match = Float @match
    end

    def parse_string_array text
      parse_text(/^\{([^}{]+?)?\}(,\s*)?/x, text)
      @match = @match.split(/",\s*"/).map { |s| s.gsub(/^"|"$/, "") }
    end

    def parse_int_array text
      parse_text(/^\{([+\-0-9,\s]+?)?\}(,\s*)?/x, text)
      @match = @match.split(/,\s*/).map { |s| Integer s }
    end

    def parse_long_array text
      parse_text(/^\{([+\-0-9L,\s]+?)?\}(,\s*)?/x, text)
      @match = @match.split(/,\s*/).map { |s| Integer s.gsub(/L$?/, "") }
    end

    def parse_double_array text
      parse_text(/^\{([+\-0-9.,\s]+?)?\}(,\s*)?/x, text)
      @match = @match.split(/,\s*/).map { |s| Float s }
    end

    def parse_text(pattern, text)
      match = pattern.match text
      @match = match[1]               if match && match.length > 1
      @match_length = match[0].length if match && match.length > 0
      @match = ''                     if @match.nil?
      @match_length = 0               if @match_length.nil?
    end
  end
end
