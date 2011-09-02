require 'spec_helper'

module Topcgen
  module JAVA
    describe Package do
      it "should should generate packaging information" do
        package = Package.new('KiloManX', 'top.coder', 'Dynamic Programming, Search, Recursion')
        package.main_package.should eq 'top.coder.dynamic'
        package.test_package.should eq 'top.coder.test.dynamic'
        package.main_class_name.should eq 'KiloManX'
        package.test_class_name.should eq 'KiloManXTest'
        package.src_folder.should eq 'src/dynamic'
        package.src_file.should eq 'src/dynamic/KiloManX.java'
        package.test_folder.should eq 'test/dynamic'
        package.test_file.should eq 'test/dynamic/KiloManXTest.java'
      end
    end
  end
end
