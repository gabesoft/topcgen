module Topcgen
  module JAVA
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

    class U             # utility class
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
