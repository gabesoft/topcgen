module Topcgen
  module JAVA
    def self.problem_class(stream, data)
      # TODO: write unit tests by comparing to an existing file
      'not_implemented'
    end

    def self.problem_tests(stream, data)
      # TODO: write unit tests by comparing to an existing file
      #
    end

    def self.categories
      data = {}
      data['Advanced Math']           = { :package => math,        :order => 8  }
      data['Brute Force']             = { :package => easy,        :order => 16 }
      data['Dynamic Programming']     = { :package => dynamic,     :order => 1  }
      data['Encryption/Compression']  = { :package => encryption,  :order => 12 }
      data['Geometry']                = { :package => geometry,    :order => 7  }
      data['Graph Theory']            = { :package => graph,       :order => 3  }
      data['Greedy']                  = { :package => greedy,      :order => 2  }
      data['Math']                    = { :package => math,        :order => 9  }
      data['Recursion']               = { :package => recursion,   :order => 11 }
      data['Search']                  = { :package => search,      :order => 4  }
      data['Simple Math']             = { :package => math,        :order => 10 }
      data['Simple Search']           = { :package => search,      :order => 5  }
      data['Iteration']               = { :package => search,      :order => 6  }
      data['Simulation']              = { :package => simulation,  :order => 15 }
      data['Sorting']                 = { :package => sorting,     :order => 14 }
      data['String Manipulation']     = { :package => stringm,     :order => 17 }
      data['String Parsing']          = { :package => parsing,     :order => 13 }
      data
    end
  end
end
