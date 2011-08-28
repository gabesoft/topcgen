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

    def parse_string text
      patt = /^"(.+?)"(,\s*)?/x
      match = patt.match text
      @match = match[1]
      @match_length = match[0].length
    end

    def parse_int text
      patt = /^(\d+)(,\s*)?/x
      match = patt.match text
      @match = Integer match[1]
      @match_length = match[0].length
    end

    def parse_long text
      patt = /^(\d+)(L?,\s*)?/x
      match = patt.match text
      @match = Integer match[1]
      @match_length = match[0].length
    end

    def parse_string_array text
      patt = /^\{(.+?)\}(,\s*)?/x
      match = patt.match text
      @match = match[1].split(/,\s*/).map do |s|
        s.gsub(/^"|"$/, "")
      end
      @match_length = match[0].length
    end

    def parse_int_array text
      patt = /^\{(.+?)\}(,\s*)?/x
      match = patt.match text
      @match = match[1].split(/,\s*/).map do |s|
        Integer s
      end
      @match_length = match[0].length
    end

    def parse_long_array text
      patt = /^\{(.+?)\}(,\s*)?/x
      match = patt.match text
      @match = match[1].split(/,\s*/).map do |s|
        Integer s.gsub(/L$?/, "")
      end
      @match_length = match[0].length
    end
  end
end
