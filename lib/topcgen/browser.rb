
module Topcgen
  class Browser

    def login(credentials)
      if credentials.nil? || credentials[:user].nil?
        raise 'no user specified'
      end
      if credentials.nil? || credentials[:pass].nil?
        raise 'no password specified'
      end

      puts "user: #{credentials[:user]}"
      puts "pass: #{credentials[:pass]}"
    end

    def search(class_name)
      puts "class: #{class_name}"
    end

  end
end
