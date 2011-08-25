$:.unshift(File.dirname(__FILE__))
require 'spec_helper'
require 'yaml'

module Topcgen
  describe CookieStore do
    it "should start out empty if no cookies are specified" do
      CookieStore.new.empty?.should be true
    end

    it "should accept a Hash of cookies in the constructor" do
      CookieStore.new({'test' => 'cookie'})['test'].value.should == 'cookie'
    end

    it "should be able to merge an HTTP cookie string" do
      cs = CookieStore.new({'a' => 'a', 'b' => 'b'})
      cs.merge! "a=A; path=/, c=C; path=/"
      cs['a'].value.should == 'A'
      cs['b'].value.should == 'b'
      cs['c'].value.should == 'C'
    end

    it "should have a to_s method to turn the cookies into a string for the HTTP Cookie header" do
      CookieStore.new({'a' => 'a', 'b' => 'b'}).to_s.should == 'a=a;b=b'
    end
  end

  describe CookieStoreSerializer do
    it "should save a cookie store" do
      stream = StringIO.new
      store = CookieStore.new 'a' => '1', 'b' => '2'

      CookieStoreSerializer.save stream, store
      stream.string.should eq store.to_yaml
      
      stream.close
    end

    it "should load a cookie store" do
      stream = StringIO.new
      store = CookieStore.new 'a' => '1', 'b' => '2'

      CookieStoreSerializer.save stream, store
      copy = CookieStoreSerializer.load stream
      copy.to_s.should eq store.to_s
      
      stream.close
    end
  end
end
