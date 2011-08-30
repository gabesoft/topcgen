module Topcgen
  module JAVA
    # TODO: put in java_codegen
    def self.val(type, value)
      Value.new type, value
    end

    def self.var(name, type, value=nil)
      Variable.new name, type, value
    end

    def self.pkg(path)
      Package.new path
    end

    def self.import(path, object='*', static=false)
      Import.new path, object, static
    end

    def self.ctor(type)
      New.new type
    end

    def self.arr(type, value, length=0)
      NewArray.new type, value, length
    end

    def self.comment(text)
      Comment.new text
    end

    def self.call(name, *args)
      FunCall.new name, args
    end

    # TODO: put in java_codegen_impl
    class FunCall
      def initialize(name, args)
        @name = name
        @args = args
      end

      def gen(stream, tab_count=0)
        stream.puts "#{U.tabs tab_count}#{to_s}"
      end

      def to_s
        "#{@name}(#{@args.map { |a| a.to_s }.join(', ')})"
      end
    end
    class NewArray
      def initialize(type, value, length=0)
        @type = type
        @value = value
        @length = length
      end

      def gen(stream, tab_count=0)
        stream.puts "#{U.tabs tab_count}#{to_s}"
      end

      def to_s
        "new #{@type}[#{@value.nil? ? @length : ''}]#{@value.nil? ? '' : ' ' + @value.to_s}"
      end
    end
    class New
      def initialize(type)
        @type = type
      end

      def gen(stream, tab_count=0)
        stream.puts "#{U.tabs tab_count}#{to_s}"
      end

      def to_s
        "new #{@type}()"
      end
    end

    class Value
      def initialize(type, value)
        @value = value
        @type = type
      end

      def gen(stream, tab_count=0)
        stream.puts "#{U.tabs tab_count}#{to_s}"
      end

      def to_s
        case @type
        when 'int'
          @value.to_s
        when 'long'
          "#{@value}L"
        when 'String'
          "\"#{@value}\""
        when 'int[]'
          "{ #{@value.join(', ')} }"
        when 'long[]'
          "{ #{@value.map { |v| "#{v}L" }.join(', ')} }"
        when 'String[]'
          "{ #{@value.map { |v| "\"#{v}\"" }.join(', ')} }"
        end
      end
    end

    class Variable
      def initialize(name, type, value=nil)
        @name = name
        @type = type
        @value = value
      end

      def gen(stream, tab_count=0)
        stream.puts "#{U.tabs tab_count}#{@type} #{@name}#{@value.nil? ? '' : ' = ' + @value.to_s};"
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
