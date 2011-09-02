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
      query = get_search_params class_name
      url = get_uri :ProblemArchive, query
      response = http_get url

      result = ProblemSearch.new response.body
      result.links.map do |link|
        get_detail link
      end
    end

    def get_statement link
      url = get_uri(nil, nil, link)
      response = http_get url
      ProblemStatement.new response.body
    end

    def get_solution link
      # TODO: try to get the tests from the solution
      #       on failure get them from the problem statement
      url = get_uri(nil, nil, link)
      response = http_get url
      ProblemSolution.new response.body
    end

    private

    def get_detail link
      url = get_uri(nil, nil, link)
      response = http_get url
      detail = ProblemDetail.new response.body
      detail[:statement_link_full] = get_url detail[:statement_link]
      detail
    end

    def do_login credentials
      url = get_uri
      params = {}
      params[:module] =	:Login
      params[:nextpage] = get_url '/tc'
      params[:password] = credentials[:pass]
      params[:username] = credentials[:user]
      http_post url, params
    end

    def do_logout
      url = get_uri :Logout
      http_get url
    end

    def go_home
      url = get_uri :MyHome
      http_get url
    end

    def login_successfull response
      !response.body.include?('name="frmLogin"')
    end

    def update_cookies response
      @cookies.merge! response['Set-Cookie']
    end

    def get_search_params class_name
      params = {}
      params[:class] = class_name         # class name
      params[:cat] = nil                  # category
      params[:div1l] = nil                # division I level
      params[:div2l] = nil                # division II level
      params[:maxd1s] = nil	              # maximum division I success rate 	%
      params[:maxd2s] = nil               #	maximum division II success rate 	%
      params[:mind1s] = nil	              # minimum division I success rate 	%
      params[:mind2s] = nil	              # minimum division II success rate 	%
      params[:er] = nil	
      params[:sc] = nil
      params[:sd] = nil
      params[:sr] = nil
      params[:wr] = nil                   # writer
      params 
    end

    def http_get url
      response = HTTP.get(url, @cookies)
      update_cookies response
      response 
    end

    def http_post(url, params)      
      response = HTTP.post(url, @cookies, params)
      update_cookies response
      response
    end

    def get_uri(module_name=nil, params=nil, relative_path='/tc')
      query = params.nil? ? {} : params
      query[:module] = module_name unless module_name.nil?
      url = get_url(relative_path, query)
      URI.parse url
    end

    def get_url(relative_path, query_hash={})
      base = "http://community.topcoder.com#{relative_path}"

      query = query_hash.map do |key, value|
        param = value.nil? ? '' : value
        param = param.to_s if param.is_a? Symbol
        param = URI.escape(param, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
        "#{key}=#{param}"
      end.join '&'

      base + (query.empty? ? '' : '?') + query
    end
  end
end
