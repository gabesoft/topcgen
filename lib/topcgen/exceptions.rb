module Topcgen
  class TopcgenException < Exception
    attr_reader :cause

    def initialize(message, cause=$!)
      @cause = cause
      super(message || cause && cause.message)
    end


    def set_backtrace bt
      if @cause
        @cause.backtrace.reverse.each do |line|
          if bt.last == line
            bt.pop
          else
            break
          end
        end
        bt << "cause: #{@cause.class.name}: #{@cause}"
        bt.concat @cause.backtrace
      end
      super bt
    end

  end

  class ParseException < TopcgenException
    def initialize str
      message = nil
      message = "failed to parse string: #{str.strip}" unless str.nil?
      super(message)
    end
  end

  class ValueParseException < TopcgenException
    def initialize(type, str)
      message = "failed to parse a value of type #{type} from '#{str}'"
      super(message)
    end
  end
end
