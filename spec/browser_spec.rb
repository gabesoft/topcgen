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

      results[0][:solution_java].should eq '/stat?c=problem_solution&cr=271521&rd=4725&pm=2268'
      results[0][:solution_cpp].should eq '/stat?c=problem_solution&cr=287130&rd=4725&pm=2268'
      results[0][:solution_csharp].should eq '/stat?c=problem_solution&cr=7454570&rd=4725&pm=2268'
      results[0][:solution_vb].should eq '/stat?c=problem_solution&cr=7532592&rd=4725&pm=2268'

      results[1][:solution_java].should eq '/stat?c=problem_solution&cr=277659&rd=4725&pm=2288'
      results[1][:solution_cpp].should eq '/stat?c=problem_solution&cr=262936&rd=4725&pm=2288'
      results[1][:solution_csharp].should be nil
      results[1][:solution_vb].should be nil
    end

    it "should get the problem statement" do
      statement_url = '/stat?c=problem_statement&pm=2449&rd=5073'
      @specWeb.register_get(statement_url, (get_contents 'spec/files/statement_dungeon_escape.html'))

      statement = @browser.get_statement statement_url
      statement[:class].should eq 'DungeonEscape'
      statement[:method].should eq 'exitTime'
      statement[:parameters].should eq 'String[], String[], String[], String[], int, int'
      statement[:returns].should eq 'int'
      statement[:signature].should eq 'int exitTime(String[] up, String[] down, String[] east, String[] west, int startLevel, int startEasting)'
    end

    it "should get the problem solution with tests" do
      solution_url = '/stat?c=problem_solution&cr=287266&rd=5073&pm=2449'
      @specWeb.register_get(solution_url, (get_contents 'spec/files/solution_dungeon_escape.html'))

      solution = @browser.get_solution solution_url
      solution.tests.length.should eq 41
      solution.tests[0].should eq ({:arguments=>"{\"0x4\", \"0x3\", \"0x3\"},\n              {\"0x9\", \"009\", \"0x9\"},\n              {\"0x9\", \"1x9\", \"009\"},\n              {\"0x9\", \"0x0\", \"009\"},\n              2,\n              2", :expected=>"10"})
      solution.tests[-1].should eq ({:arguments=>"{\"91\"},\n              {\"99\"},\n              {\"11\"},\n              {\"11\"},\n              0,\n              0", :expected=>"2"})
    end

    def get_contents file
      File.open(file, 'r') do |stream|
        stream.read
      end
    end
  end
end
