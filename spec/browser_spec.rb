require 'spec_helper'

module Topcgen
  describe Browser do
    before :each do
      @browser = Browser.new
    end

    it "should login successfully with valid credentials" do
      settings = Settings.read_file 'settings.yml'
      @browser.login settings[:credentials]
      @browser.logged_in.should eq true
    end

    it "should fail to login with invalid credentials" do
      credentials = { :user => 'fuser', :pass => 'fpass' }
      @browser.login credentials
      @browser.logged_in.should eq false
    end

    it "should logout successfully" do
      @browser.logout
      @browser.logged_in.should eq false
    end
  end
end
