module Topcgen
  module JAVA
    class ClassGen
      def initialize(name, fields, methods, comments, visibility)
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

    class MethodGen
      def initialize(name, return_type, parameters, statements, annotation, comment, visibility)
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

    class ReturnGen
      def initialize(value)
        @value = value
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}return #{@value.to_s};"
      end
    end

    class FunCallGen
      def initialize(name, args)
        @name = name
        @args = args
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}#{to_s};"
      end

      def to_s
        "#{@name}(#{@args.map { |a| a.to_s }.join(', ')})"
      end
    end

    class NewArrayGen
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
    class NewGen
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

    class ValueGen
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
        else
          raise "don't know how to convert value of type #{@type} to string"
        end
      end
    end

    class VariableGen
      def initialize(type, name, value=nil)
        @name = name
        @type = type
        @value = value
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}#{@type} #{@name}#{@value.nil? ? '' : ' = ' + @value.to_s};"
      end
    end

    class PackageGen
      def initialize path
        @path = path
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}package #{@path};"
      end
    end

    class ImportGen
      def initialize(path, object, static)
        @path = path
        @object = object
        @static = static
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}import#{@static ? ' static' : ''} #{@path}.#{@object};"
      end
    end

    class CommentGen
      def initialize text
        @text = text
      end

      def gen(stream, tab_count=0)
        stream.puts "#{T.tabs tab_count}// #{@text}"
      end
    end

    class AnnotationGen
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

    class BlankGen
      def gen(stream, tab_count=0)
        stream.puts ''
      end
    end

    class MultipleGen
      def initialize statements
        @statements = statements
      end

      def gen(stream, tab_count=0)
        @statements.each do |s|
          s.gen stream, tab_count
        end
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
