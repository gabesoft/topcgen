module Topcgen
  module JAVA
    def self.main_class(stream, method_def, info)
      gen_main_package(stream, info[:package_root], info[:categories])
      gen_main_imports(stream, info[:main_imports])
      gen_main_class(stream, method_def, info)
    end

    def self.test_class(stream, method_def, info, tests)
      gen_test_package(stream, info[:package_root], info[:categories])
      gen_test_imports(stream, info[:test_imports], info[:package_root], info[:categories])
      gen_test_class(stream, method_def, info, tests)
    end

    def self.get_paths(method_def, info)
      {} # TODO: add unit tests first
    end

    private

    def self.gen_test_package(stream, package_root, categories)
      gen_package stream, "#{package_root}.test", categories
    end

    def self.gen_test_imports(stream, imports, package_root, categories)
      imports = imports.clone()
      package = get_package package_root, categories
      imports.push({ :path => package })
      gen_imports stream, imports
    end

    def self.gen_test_class(stream, method_def, info, tests)
      field = var info[:name], info[:name].downcase, (ctor info[:name])

      args_def = method_def.parameters
      return_type = method_def.return_type
      return_type_is_array = !(/\[\]$/ =~ return_type).nil?

      assert_name = return_type_is_array ? 'assertArrayEquals' : 'assertEquals'
      actual_arguments = args_def.map { |p| p[:name] }
      actual = call "#{info[:name].downcase}.#{method_def.name}", *actual_arguments
      test_annotation = annotation 'Test'

      methods = tests.each_with_index.map do |t, i|
        name = "case#{i + 1}"
        args = t[:arguments]

        statements = args_def.zip(args).map { |a, v| var a[:type], a[:name], (val a[:type], v) }

        expected = return_type_is_array ? arr(return_type, t[:expected]) : val(return_type, t[:expected])
        assert_call = call assert_name, expected, actual

        statements.push assert_call
        test_method = method(name, 'void', nil, statements, test_annotation)
        combine test_method, newline
      end

      test_class_name = "#{info[:name]}Test"
      test_class = clas test_class_name, [ field ], methods
      test_class.gen stream
    end

    def self.gen_main_package(stream, package_root, categories)
      gen_package stream, package_root, categories
    end

    def self.gen_package(stream, package_root, categories)
      package_path = get_package package_root, categories
      package_gen = pkg package_path
      package_gen.gen stream
      newline.gen stream
    end

    def self.gen_main_imports(stream, imports)
      gen_imports stream, imports
    end

    def self.gen_imports(stream, imports)
      imports.each do |i|
        import_gen = import i[:path], i[:object], i[:static]
        import_gen.gen stream
      end
      newline.gen stream if imports.length > 0;
    end

    def self.gen_main_class(stream, method_def, info)
      comments = [
        comment(info[:used_in] + ' ' + info[:used_as] + ' - ' + info[:point_value]),
        comment(info[:categories].downcase),
        comment(info[:statement_link_full]) ]

      return_type = method_def.return_type
      return_statement = ret (default return_type)
      main_method = method(method_def.name, return_type, method_def.parameters, [ return_statement ])
      debug_method = get_debug_method
      
      class_gen = clas(info[:name], nil, [ main_method, newline, debug_method ], comments)
      class_gen.gen stream
    end

    def self.get_debug_method
      argument = 'os'
      statement = call 'System.out.println', (call 'Arrays.deepToString', argument)
      parameter = { :type => 'Object...', :name => argument }
      method 'debug', 'void', [ parameter ], [ statement ], nil, nil, 'private'
    end

    def self.get_package(package_root, problem_categories)
      all_categories = get_categories
      categories = problem_categories.split(/,\s*/).map do |c|
        all_categories[c]
      end
      categories.sort! { |c| c[:order] }
      "#{package_root}.#{categories[-1][:package]}"
    end

    def self.get_categories
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
