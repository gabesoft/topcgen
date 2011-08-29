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
      when 'String[]'
        parse_string_array text
      when 'int[]'
        parse_int_array text
      when 'long[]'
        parse_long_array text
      else
        raise "don't know how to parse values of type #{@type}"
      end
    end

    private

    def parse_string text
      parse_text(/^"(.+?)"(,\s*)?/x, text)
    end

    def parse_int text
      parse_text(/^(\d+)(,\s*)?/x, text)
      @match = Integer @match
    end

    def parse_long text
      parse_text(/^(\d+)(L?,\s*)?/x, text)
      @match = Integer @match
    end

    def parse_string_array text
      parse_text(/^\{(.+?)\}(,\s*)?/x, text)
      @match = @match.split(/,\s*/).map { |s| s.gsub(/^"|"$/, "") }
    end

    def parse_int_array text
      parse_text(/^\{(.+?)\}(,\s*)?/x, text)
      @match = @match.split(/,\s*/).map { |s| Integer s }
    end

    def parse_long_array text
      parse_text(/^\{(.+?)\}(,\s*)?/x, text)
      @match = @match.split(/,\s*/).map { |s| Integer s.gsub(/L$?/, "") }
    end

    def parse_text(pattern, text)
      match = pattern.match text
      @match = match[1]
      @match_length = match[0].length
    end
  end
end
