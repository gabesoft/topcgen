require 'net/https'
require 'hpricot'
#require 'cgi'
#require 'iconv'

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
      url = get_uri('ProblemArchive', query)

      response = HTTP.get(url, @cookies)
      update_cookies response

      doc = Hpricot response.body
      container = doc/"form[@name='problemListForm']"

      links = container/'a.statText'
      links
      .find_all { |a| a.inner_html.include? 'details' }
      .map { |a| get_uri(nil, nil, a.attributes['href']) }
      .map { |a| get_detail a }
      #
      #puts response.body
      #<A HREF="/tc?module=ProblemDetail&rd=4725&pm=2268" class="statText">details</A>
      #<form name="problemListForm" method="get">
    end

    private

    def get_detail url
      response = HTTP.get(url, @cookies)
      doc = Hpricot response.body
      container = doc/'div.statTableIndent'

      stmt_link = (container/'a.statText').find { |a| a.attributes['href'].include? 'problem_statement' }
      round_link = (container/'a.statText').find { |a| a.attributes['href'].include? 'round_overview' }
      row_used_as = (container/'tr').find { |tr| tr.inner_html.include? 'Used As:' }
      row_categories = (container/'tr').find { |tr| tr.inner_html.include? 'Categories:' }
      row_point_value = (container/'tr').find { |tr| tr.inner_html.include? 'Point Value' }

      detail = {}
      detail[:name] = stmt_link.inner_html.strip
      detail[:statement_link] = stmt_link.attributes['href']
      detail[:used_in] = round_link.inner_html.strip
      detail[:used_as] = (row_used_as/'td')[1].inner_html.strip
      detail[:categories] = (row_categories/'td')[1].inner_html.strip
      detail[:point_value] = (row_point_value/'td')[1].inner_html.strip

      puts detail
      detail
    end

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

    def get_uri(module_name=nil, params=nil, relative_path='/tc')
      query = params.nil? ? {} : params
      query[:module] = module_name unless module_name.nil?
      url = get_url(relative_path, query)
      URI.parse url
    end

    def get_url(relative_path, query_hash={})
      base = "http://community.topcoder.com#{relative_path}"

      query = query_hash.map do |key, value|
        param = value.nil? ? '' : URI.escape(value, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
        "#{key}=#{param}"
      end.join '&'

      base + (query.empty? ? '' : '?') + query
    end
  end
end
