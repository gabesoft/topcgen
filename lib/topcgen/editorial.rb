module Topcgen
  class Editorial
    def self.get_link(used_in)
      if used_in =~ /^SRM/
        SRM.get_link(used_in)
      elsif used_in =~ /^TCO/
        TCO.get_link(used_in)
      elsif used_in =~ /^TCCC/
        TCCC.get_link(used_in)
      elsif used_in =~ /^TCI/
        TCI.get_link(used_in)
      elsif used_in =~ /^CRPF/
        CRPF.get_link(used_in)
      end
    end
  end

  class SRM
    def self.get_link(used_in)
      pat = /^SRM (\d+\.?\d*)/
      match = pat.match used_in
      num = match[1]
      EditorialLinks.getSRM num
    end
  end

  class TCO

  end

  class TCI

  end

  class TCCC

  end

  class CRPF

  end

  class EditorialLinks
    def self.initialize
      populate_map
    end

    def self.getSRM num
      if num < "103" 
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=srm#{num}_room1"
      elsif num == "103"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=srm103_rookie"
      elsif num < "433"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=srm#{num}"
      elsif num == "455" || num == "458" || num == "461" || num == "465" || num == "503"
        "http://apps.topcoder.com/wiki/display/tc/Member+SRM+#{num}"
      else
        "http://apps.topcoder.com/wiki/display/tc/SRM+#{num}"
      end
    end

    private

    def self.populate_map
      @map = {}
    end
  end

end
