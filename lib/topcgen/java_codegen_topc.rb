module Topcgen
  module JAVA
    def self.problem_class(stream, method_def, info)
      gen_package(stream, info[:package_root], info[:categories])
      gen_imports(stream, info[:imports])
      gen_class(stream, method_def, info)
    end

    def self.problem_tests(stream, method_def, info, tests)
      gen_test_package(stream, info[:package_root], info[:categories])
      gen_test_imports(stream, info[:imports], info[:package_root], info[:categories])
      gen_test_class(stream, method_def, info, tests)
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
      return_type = method_def.return_type
      params = method_def.parameters

      methods = tests.each_with_index.map do |t, i|
        name = "case#{i + 1}"
        args = t[:arguments]
        variable_declarations = params.zip(args).map do |p, v|
          var p[:type], p[:name], (val p[:type], v)
        end

        assert_name = is_array(return_type) ? 'assertArrayEquals' : 'assertEquals'
        expected = is_array(return_type) ? arr(return_type, t[:expected]) : val(return_type, t[:expected])
        actual_arguments = params.map { |p| p[:name] }
        actual = call "#{info[:name].downcase}.#{method_def.name}", *actual_arguments
        assert_call = call assert_name, expected, actual
        test_annotation = annotation 'Test'

        statements = variable_declarations + [ assert_call ]
	      method(name, 'void', nil, statements, test_annotation)
      end

      test_class_name = "#{info[:name]}Test"
      test_class = clas test_class_name, [ field ], methods
      test_class.gen stream
    end

    def self.is_array type
      !(/\[\]$/ =~ type).nil?
    end

    def self.gen_package(stream, package_root, categories)
      package_path = get_package package_root, categories
      pkg_gen = pkg package_path
      pkg_gen.gen stream
      stream.puts ''
    end

    def self.gen_imports(stream, imports)
      imports.each { |i| 
        import(i[:path], i[:object], i[:static]).gen stream 
      }
      stream.puts '' if imports.length > 0;
    end

    def self.gen_class(stream, method_def, info)
      comments = [ 
        comment(info[:used_in] + ' ' + info[:used_as] + ' - ' + info[:point_value]),
        comment(info[:categories].downcase), 
        comment(info[:statement_link_full]) 
      ]
      return_gen = ret (default method_def.return_type) 
      method_gen = method(method_def.name, method_def.return_type, method_def.parameters, [ return_gen ])
      class_gen = clas(info[:name], nil, [ method_gen ], comments)
      class_gen.gen stream
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
