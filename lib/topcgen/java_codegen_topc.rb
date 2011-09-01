module Topcgen
  module JAVA
    def self.problem_class(stream, method_def, info)
      gen_package(stream, info)
      gen_imports(stream, info)
      gen_class(stream, method_def, info)
    end

    def self.problem_tests(stream, data)
      # TODO: write unit tests by comparing to an existing file
      #
    end

    private

    def self.gen_package(stream, info)
      package_path = get_package info[:package_root], info[:categories]
      pkg(package_path).gen stream
      stream.puts ''
    end

    def self.gen_imports(stream, info)
      imports = info[:imports]
      imports.each { |i| import(i).gen stream }
      stream.puts '' if imports.length > 0;
    end

    def self.gen_class(stream, method_def, info)
      comments = [ 
        comment(info[:used_in] + ' ' + info[:used_as] + ' - ' + info[:point_value]),
        comment(info[:categories]), 
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
