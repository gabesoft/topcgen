module Topcgen
  module JAVA
    # TODO: refactor and put necessary values in settings
    #
    def self.problem_class(stream, defn, info)
      pkg(get_package info[:categories]).gen stream
      stream.puts ''

      import('java.util').gen stream # TODO: this should come from settings
      stream.puts ''
      
      comments = [ 
        comment(info[:used_in] + ' ' + info[:used_as] + ' - ' + info[:point_value]),
        comment(info[:categories]), 
        comment(info[:statement_link_full]) 
      ]
      return_gen = ret (default defn.return_type) 
      method_gen = method(defn.name, defn.return_type, nil, nil, defn.parameters, [ return_gen ])
      class_gen = clas(info[:name], comments, nil, [ method_gen ])
      class_gen.gen stream
    end

    def self.problem_tests(stream, data)
      # TODO: write unit tests by comparing to an existing file
      #
    end

    private

    def self.get_package problem_categories
      root = 'topc' # TODO: this should come from settings
      all_categories = get_categories
      categories = problem_categories.split(/,\s*/).map do |c|
        all_categories[c]
      end
      categories.sort! { |c| c[:order] }
      "#{root}.#{categories[-1][:package]}"
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
