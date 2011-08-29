module Topcgen
  module JAVA
    # TODO: how do we deal with field declaration with assignment
    #       vs just an assignment
    #       int x = 8;
    #       x = 9;
    #class Field
      
    #end

    class Val
      def initialize(value, type)
        @value = value
        @type = type
      end

      def gen stream
        case @type
        when 'int'
          stream << @value
        when 'long'
          stream << "#{@value}L"
        when 'String'
          stream << "\"#{@value}\""
        when 'int[]'
          stream << "{ #{@value.join(', ')} }"
        when 'long[]'
          stream << "{ #{@value.map { |v| "#{v}L" }.join(', ')} }"
        when 'String[]'
          stream << "{ #{@value.map { |v| "\"#{v}\"" }.join(', ')} }"
        end
      end
    end
    
    class Var
      def initialize name
        @name = name
      end

      def gen stream
        stream << @name
      end
    end

    class Package
      def initialize path
        @path = path
      end

      def gen(stream, tab_count=0)
        stream.puts "#{U.tabs tab_count}package #{@path};"
      end
    end

    class Import
      def initialize(path, object='*', static=false)
        @path = path
        @object = object
        @static = static
      end

      def gen(stream, tab_count=0)
        stream.puts "#{U.tabs tab_count}import#{@static ? ' static' : ''} #{@path}.#{@object};"
      end
    end

    class Comment
      def initialize text
        @text = text
      end

      def gen(stream, tab_count=0)
        stream.puts "#{U.tabs tab_count}// #{@text}"
      end
    end

    class U
      @@TAB_SIZE = 2

      def self.tabs tab_count
        ' ' * @@TAB_SIZE * tab_count
      end

      def self.set_tab_size size
        @@TAB_SIZE = size
      end
    end

    def self.set_tab_size size
      U.set_tab_size size
    end
  end
end
