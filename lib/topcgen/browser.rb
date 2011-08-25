
module Topcgen
  class Browser

    def login(credentials)
      if !credentials || !credentials['user']
        raise 'no user specified'
      end
      if !credentials || !credentials['pass']
        raise 'no password specified'
      end

      puts "user: #{credentials['user']}"
      puts "pass: #{credentials['pass']}"
    end

    def search(class_name)
      puts "class: #{class_name}"
    end

  end
end
