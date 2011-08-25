
module Topcgen
  class Browser

    def login credentials
      puts "user: #{credentials[:user]}"
      puts "pass: #{credentials[:pass]}"
    end

    def search class_name
      puts "class: #{class_name}"
    end

  end
end
