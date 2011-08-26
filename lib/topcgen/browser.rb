require 'net/https'

module Topcgen
  class Browser
    attr_accessor :logged_in

    def initialize
      @cookies = CookieStore.new
      @logged_in = false
      @tc_url = 'http://community.topcoder.com/tc'
    end

    def login(credentials)

      if credentials.nil? || credentials[:user].nil?
        raise 'no user specified'
      end
      if credentials.nil? || credentials[:pass].nil?
        raise 'no password specified'
      end

      do_login credentials
      response = go_home
      @logged_in = login_successfull response
    end

    def logout
      do_logout
      response = go_home
      @logged_in = login_successfull response
    end

    def search(class_name)
      puts "class: #{class_name}"
    end

    private

    def do_login credentials
      url = get_uri
      params = {}
      params[:module] =	'Login'
      params[:nextpage] = 'http://community.topcoder.com/tc'
      params[:password] = credentials[:pass]
      params[:username] = credentials[:user]
      response = HTTP.post(url, @cookies, params)
      update_cookies response
      response
    end

    def do_logout
      url = get_uri 'Logout'
      response = HTTP.get(url, @cookies)
      update_cookies response
      response
    end

    def go_home
      url = get_uri 'MyHome'
      response = HTTP.get(url, @cookies)
      update_cookies response
      response
    end

    def login_successfull response
      !response.body.include?('name="frmLogin"')
    end

    def update_cookies response
      @cookies.merge! response['Set-Cookie']
    end

    def get_uri(module_name=nil)
      query = module_name.nil? ? {} : { :module => module_name }
      url = get_url query
      URI.parse url
    end

    def get_url(query_hash={})
      base = 'http://community.topcoder.com/tc'

      query = query_hash.map do |key, value|
        param = URI.escape value, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
        "#{key}=#{param}"
      end.join '&'

      base + (query.empty? ? '' : '?') + query
    end
  end
end
