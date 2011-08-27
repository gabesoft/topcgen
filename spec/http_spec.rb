require 'spec_helper'
require 'net/https'

module Topcgen
  describe HTTP do
    before :each do
      @specWeb = SpecWeb.new('http://www.myapp.com/', 'https://www.myapp.com/')
    end

    describe "get" do
      it "should make a get request and return the page body" do
        @specWeb.register_get 'page1', 'page1'
        html = HTTP.get (URI.parse "http://www.myapp.com/page1"), CookieStore.new
        html.body.should include "page1"
      end
    end

    describe "post" do
      it "should make a post request and return the page body" do
        @specWeb.register_post 'page2?a=b&c=d', 'page2', true

        url = "https://www.myapp.com/page2?a=b&c=d"
        uri = URI.parse url
        html = HTTP.post uri, CookieStore.new, {}

        response = "page2"
        html.body.should eq response
      end
    end
  end
end
