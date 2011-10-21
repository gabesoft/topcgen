module Topcgen
  module JAVA
    class Package
      attr_reader :main_package
      attr_reader :test_package
      attr_reader :main_class_name
      attr_reader :test_class_name
      attr_reader :test_runner_package
      attr_reader :test_runner_class_name
      attr_reader :src_folder
      attr_reader :src_file
      attr_reader :test_folder
      attr_reader :test_file
      attr_reader :test_runner_file

      def initialize(class_name, package_root, categories)
        @categories = categories
        @all_categories = get_all_categories

        @main_class_name        = class_name
        @test_class_name        = "#{class_name}Test"
        @test_runner_class_name  = "AllTests"

        @rel_package  = get_rel_package

        @src_folder   = "src/#{@rel_package}"
        @test_folder  = "test"

        @src_file         = "#{@src_folder}/#{@main_class_name}.java"
        @test_file        = "#{@test_folder}/#{@rel_package}/#{@test_class_name}.java"
        @test_runner_file  = "#{@test_folder}/#{@test_runner_class_name}.java"

        @main_package         = "#{package_root}.#{@rel_package}"
        @test_package         = "#{package_root}.test.#{@rel_package}"
        @test_runner_package   = "#{package_root}.test"
      end

      private

      def get_rel_package
        categories = @categories.split(/,\s*/).map { |c| @all_categories[c] }
        categories.sort! { |c| c[:order] }
        categories[-1][:package]
      end

      def get_all_categories
        data = {}
        data['Advanced Math']           = { :package => 'math',        :order => 8  }
        data['Brute Force']             = { :package => 'easy',        :order => 16 }
        data['Dynamic Programming']     = { :package => 'dynamic',     :order => 1  }
        data['Encryption/Compression']  = { :package => 'encryption',  :order => 12 }
        data['Geometry']                = { :package => 'geometry',    :order => 7  }
        data['Graph Theory']            = { :package => 'graph',       :order => 3  }
        data['Greedy']                  = { :package => 'greedy',      :order => 2  }
        data['Math']                    = { :package => 'math',        :order => 9  }
        data['Recursion']               = { :package => 'recursion',   :order => 11 }
        data['Search']                  = { :package => 'search',      :order => 4  }
        data['Simple Math']             = { :package => 'math',        :order => 10 }
        data['Simple Search']           = { :package => 'search',      :order => 5  }
        data['Iteration']               = { :package => 'search',      :order => 6  }
        data['Simulation']              = { :package => 'simulation',  :order => 15 }
        data['Sorting']                 = { :package => 'sorting',     :order => 14 }
        data['String Manipulation']     = { :package => 'stringm',     :order => 17 }
        data['String Parsing']          = { :package => 'parsing',     :order => 13 }
        data
      end
    end
  end
end
