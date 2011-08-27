require 'spec_helper'
require 'net/https'

module Topcgen
  describe Browser do
    @ignore = true

    before :each do
      @browser = Browser.new
      @specWeb = SpecWeb.new('http://community.topcoder.com', 'https://community.topcoder.com')
    end

    it "should login successfully with valid credentials", :if => !@ignore do
      settings = Settings.read_file '.topcgen.yml'
      @browser.login settings[:credentials]
      @browser.logged_in.should eq true
    end

    it "should fail to login with invalid credentials", :if => !@ignore do
      credentials = { :user => 'fuser', :pass => 'fpass' }
      @browser.login credentials
      @browser.logged_in.should eq false
    end

    it "should logout successfully", :if => !@ignore do
      @browser.logout
      @browser.logged_in.should eq false
    end

    it "should search by class name" do
      search_url = '/tc?class=kilo&cat=&div1l=&div2l=&maxd1s=&maxd2s=&mind1s=&mind2s=&er=&sc=&sd=&sr=&wr=&module=ProblemArchive'
      detail1_url = '/tc?module=ProblemDetail&rd=4725&pm=2268'
      detail2_url = '/tc?module=ProblemDetail&rd=4725&pm=2288'

      @specWeb.register_get(search_url, (get_contents 'spec/files/search.html'))
      @specWeb.register_get(detail1_url, (get_contents 'spec/files/detail_kiloman.html'))
      @specWeb.register_get(detail2_url, (get_contents 'spec/files/detail_kilomanx.html'))

      class_name = 'kilo'
      results = @browser.search class_name
      results.count.should eq 2

      results[0][:name].should eq 'KiloMan'
      results[0][:statement_link].should eq '/stat?c=problem_statement&pm=2268&rd=4725'
      results[0][:used_in].should eq 'SRM 181'
      results[0][:used_as].should eq 'Division II Level One'
      results[0][:categories].should eq 'Simulation, Dynamic Programming, Search'
      results[0][:point_value].should eq '250'
    end

    def get_contents file
      File.open(file, 'r') do |stream|
        stream.read
      end
    end
  end
end
