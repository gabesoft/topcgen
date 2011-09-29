require 'spec_helper'

module Topcgen
  describe Editorial do
    it "should get link for SRM 146 Division II Level Three" do
      link = Editorial.get_link("SRM 146 Division II Level Three")
      link.should eq "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=srm146"
    end

    it "should get link for CRPF Charity Finals Division I Level One" do
      link = Editorial.get_link("CRPF Charity Finals Division I Level One")
      link.should eq "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=crpf_finals"
    end

    it "should get link for TCI '02 Semifinals 4 Division I Level Three (Room 4)" do
      link = Editorial.get_link("TCI '02 Semifinals 4 Division I Level Three")
      link.should eq "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tci02&d3=semiprob4"
    end

    it "should get link for TCI '02 Round 1 B Division I Level Two" do
      link = Editorial.get_link("TCI '02 Round 1 B Division I Level Two")
      link.should eq "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=invit02_r1b"
    end

    it "should get link for SRM 453.5 Division II Level One" do
      link = Editorial.get_link("SRM 453.5 Division II Level One")
      link.should eq "http://apps.topcoder.com/wiki/display/tc/SRM+453.5"
    end

    it "should get link for TCI '02 Finals Division I Level One" do
      link = Editorial.get_link("TCI '02 Finals Division I Level One")
      link.should eq "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tci02&d3=champprob"
    end

    it "should get link for CRPF Charity Round 1 Division I Level One" do
      link = Editorial.get_link("CRPF Charity Round 1 Division I Level One")
      link.should eq "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=crpf_rd1"
    end

    it "should get link for TCO '03 Finals Division I Level Three" do
      link = Editorial.get_link("TCO '03 Finals Division I Level Three")
      link.should eq "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tco03&d3=summary&d4=final_analysis"
    end

    it "should get link for TCO04 Semifinal 1 Division I Level Two" do
      link = Editorial.get_link("TCO04 Semifinal 1 Division I Level Two")
      link.should eq "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tco03&d3=summary&d4=room1_analysis"
    end

    it "should get link for TCO04 Round 2 Division I Level Three" do
      link = Editorial.get_link("TCO04 Round 2 Division I Level Three")
      link.should eq "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco04_online_rd_2"
    end

    it "should get link for TCCC '04 Qual. 2 Division I Level One" do
      link = Editorial.get_link("TCCC '04 Qual. 2 Division I Level One")
      link.should eq "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc04_qual_2"
    end
  end
end
