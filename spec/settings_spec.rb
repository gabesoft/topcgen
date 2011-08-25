$:.unshift(File.dirname(__FILE__))
require 'spec_helper'
require 'yaml'

module Topcgen
  describe Settings do
    it "should read settings from file" do
      credentials = { 'user' => 'auser', 'pass' => 'apass' }
      settings = Settings.read_file 'spec/files/settings.yml'
      settings['credentials'].should eq credentials
      settings['namespace_root'].should eq 'aroot'
    end
  end
end
