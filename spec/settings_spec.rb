$:.unshift(File.dirname(__FILE__))
require 'spec_helper'
require 'yaml'

module Topcgen
  describe Settings do
    it "should read settings from file" do
      credentials = { :user => 'auser', :pass => 'apass' }
      settings = Settings.read_file 'spec/files/settings.yml'
      settings[:credentials].should eq credentials
      settings[:package_root].should eq 'aroot'
    end

    it "should return an empty dictionary on non-existent file" do
      settings = Settings.read_file 'nonexistent.yml'
      settings.should eq ({})
    end
  end
end
