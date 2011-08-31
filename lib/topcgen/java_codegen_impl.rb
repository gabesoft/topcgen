module Topcgen
  module JAVA
    class Class
      def initialize(name, comments, fields, methods, visibility)
        @name = name
        @comments = comments
        @fields = fields
        @methods = methods
        @visibility = visibility
      end

      def gen(stream, tab_count=0)
        @comments.each do |c|
          c.gen(stream, tab_count)
        end
        stream.puts "#{T.tabs tab_count}#{@visibility} class #{@name} {"
        @fields.each do |f|
          f.gen(stream, tab_count + 1)
        end
        stream.puts '' if @fields.length > 0
        @methods.each do |m|
          m.gen(stream, tab_count + 1)
        end
        stream.puts "#{T.tabs tab_count}}"
      end
    end

    class Method
      def initialize(name, return_type, annotation, comment, parameters, statements, visibility)
        @name = name
        @return_type = return_type
        @annotation = annotation
        @comment = comment
        @visibility = visibility
        @parameters = parameters
        @statements = statements
      end

      def gen(stream, tab_count=0)
        @comment.gen(stream, tab_count) unless @comment.nil?
        @annotation.gen(stream, tab_count) unless @annotation.nil?

        parameters = @parameters.map { |p| p[:type] + ' ' + p[:name] }.join(', ')
        stream.puts "#{T.tabs tab_count}#{@visibility} #{@return_type} #{@name}(#{parameters}) {"
        @statements.each do |s|
          s.gen(stream, tab_count + 1)
        end
        stream.puts "#{T.tabs tab_count}}"
      end
    end

    class Return
      def initialize(value)
        @value = value
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}return #{@value.to_s};"
      end
    end

    class FunCall
      def initialize(name, args)
        @name = name
        @args = args
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}#{to_s}"
      end

      def to_s
        "#{@name}(#{@args.map { |a| a.to_s }.join(', ')})"
      end
    end
    class NewArray
      def initialize(type, value, length)
        @type = type
        @value = value
        @length = length
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}#{to_s}"
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
        stream.puts "#{T.tabs tab_count}#{to_s}"
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
        stream.puts "#{T.tabs tab_count}#{to_s}"
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
      def initialize(type, name, value=nil)
        @name = name
        @type = type
        @value = value
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}#{@type} #{@name}#{@value.nil? ? '' : ' = ' + @value.to_s};"
      end
    end

    class Package
      def initialize path
        @path = path
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}package #{@path};"
      end
    end

    class Import
      def initialize(path, object, static)
        @path = path
        @object = object
        @static = static
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}import#{@static ? ' static' : ''} #{@path}.#{@object};"
      end
    end

    class Comment
      def initialize text
        @text = text
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}// #{@text}"
      end
    end

    class Annotation
      def initialize text
        @text = text
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}#{to_s}"
      end

      def to_s
        "@#{@text}"
      end
    end

    class T
      @@TAB_SIZE = 2

      def self.tabs tab_count
        ' ' * @@TAB_SIZE * tab_count
      end

      def self.set_tab_size size
        @@TAB_SIZE = size
      end
    end

    def self.set_tab_size size
      T.set_tab_size size
    end
  end
  
end
