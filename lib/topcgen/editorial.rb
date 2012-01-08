module Topcgen
  class Editorial
    def self.get_link(used_in)
      link = nil

      if used_in =~ /^SRM/
        link = SRM.get_link(used_in)
      elsif used_in =~ /^TCO/
        link = TCO.get_link(used_in)
      elsif used_in =~ /^TCCC/
        link = TCCC.get_link(used_in)
      elsif used_in =~ /^TCI/
        link = TCI.get_link(used_in)
      elsif used_in =~ /^CRPF/
        link = CRPF.get_link(used_in)
      end

      link.nil? ? "http://apps.topcoder.com/wiki/display/tc/Algorithm+Problem+Set+Analysis" : link
    end
  end

  class SRM
    def self.get_link(used_in)
      pat = /^SRM (\d+\.?\d*)/
      match = pat.match used_in
      get match[1]
    end

    private

    def self.get num
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
  end

  class TCO
    def self.get_link(used_in)
      pat = /^TCO(\s+\d\d|\s+')?(\d\d)\s+(final|semi|round|qual|wild|champ|sponsor)(?:.*?\s+(\d+[A-Z]?))?/i
      match = pat.match used_in
      year = match[2]
      type = match[3].downcase
      num = match[4].nil? ? nil : match[4].downcase
      get year, type, num
    end

    private

    def self.get(year, type, num)
      case type
      when 'final'
        get_final year
      when 'semi' 
        get_semi year, num
      when 'round'
        get_round year, num
      when 'qual' 
        get_qual year, num
      when 'wild' 
        get_wild year
      when 'champ'
        get_champ year
      end
    end

    def self.get_champ(year)
      case year
      when "09"
        "http://apps.topcoder.com/wiki/display/tc/TCO%2709+Championship+Round"
      when "10"
        "http://apps.topcoder.com/wiki/display/tc/TCO'10+Championship+Round"
      end
    end

    def self.get_qual(year, num)
      case year
      when "03"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco03_qual_rd_#{num}"
      when "04"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco04_qual_#{num}"
      when "05"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco05_qual#{num}"
      when "06"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco06_qual"
      when "07"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco07_qual_rd#{num}"
      when "08"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco08qualRd#{num}"
      when "09"
        "http://apps.topcoder.com/wiki/display/tc/TCO%2709+Qualification+Round+#{num}"
      when "10", "11"
        "http://apps.topcoder.com/wiki/display/tc/TCO'#{year}+Qualification+Round+#{num}"
      end
    end

    def self.get_wild(year)
      case year
      when "04", "05", "06"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tco#{year}&d3=alg_wildcard_analysis"
      when "07"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tco07&d3=algorithm&d4=algoWildcard"
      when "10"
        "http://apps.topcoder.com/wiki/display/tc/TCO'10+Wildcard+Round"
      end
    end

    def self.get_round(year, num)
      case year
      when "03", "04", "05", "06"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco#{year}_online_rd_#{num}"
      when "07"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco#{year}_rd#{num}"
      when "08"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco#{year}rd#{num}"
      when "09"
        "http://apps.topcoder.com/wiki/display/tc/TCO%2709+Elimination+Round+#{num}"
      when "10", "11"
        "http://apps.topcoder.com/wiki/display/tc/TCO'#{year}+Online+Round+#{num}"
      end
    end

    def self.get_semi(year, num)
      case year
      when "03"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tco03&d3=summary&d4=room#{num}_analysis"
      when "04", "05", "06"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tco#{year}&d3=alg_room#{num}_analysis"
      when "07"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tco07&d3=algorithm&d4=algoSemi0#{num}"
      when "09"
        "http://apps.topcoder.com/wiki/display/tc/TCO%2709+Semifinal+Round"
      when "10"
        "http://apps.topcoder.com/wiki/display/tc/TCO'10+Semifinal+#{num}"
      end
    end

    def self.get_final(year)
      base = "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tco#{year}"
      case year
      when "03"
        "#{base}&d3=summary&d4=final_analysis"
      when "07"
        "#{base}&d3=algorithm&d4=algoFinals"
      else
        "#{base}&d3=alg_finals_analysis"
      end
    end
  end

  class TCCC
    def self.get_link(used_in)
      pat = /^TCCC(\s+\d\d|\s+')?(\d\d)\s+(final|semi|round|qual|wild|int'l|ne\/se|w\/mv)(?:.*?\s+(\d+[A-Z]?))?/i
      match = pat.match used_in
      year = match[2]
      type = match[3].downcase
      num = match[4].nil? ? nil : match[4].downcase
      get year, type, num
    end

    private 

    def self.get(year, type, num)
      #puts "year: #{year}, type: #{type}, num: #{num}, #{num.nil?}"
      case type
      when 'final'
        get_final year
      when 'semi' 
        get_semi year, num
      when 'round'
        get_round year, num
      when 'qual' 
        get_qual year, num
      when 'wild' 
        get_wild year
      when "int'l", "ne/se", "w/mw"
        get_regional type
      end
    end

    def self.get_final(year)
      case year
      when "03"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tccc#{year}&d3=champprob"
      when "04", "05", "06"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tccc#{year}&d3=alg_finals_analysis"
      when "07"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tccc#{year}&d3=algorithm&d4=algoFinals"
      end
    end

    def self.get_round(year, num)
      case year
      when "03"
        case num
        when "2"
          "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc03_reg_quart"
        when "3"
          "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc03_reg_semi"
        when "4"
          "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc03_regfinal"
        end
      when "04", "05", "06"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc#{year}_online_rd_#{num}"
      when "07"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc#{year}_rd#{num}"
      end
    end

    def self.get_semi(year, num)
      case year
      when "03"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tccc#{year}&d3=semiprob#{num}"
      when "04", "05", "06"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tccc#{year}&d3=alg_room#{num}_analysis"
      when "07"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tccc#{year}&d3=algorithm&d4=algoSemi0#{num}"
      end
    end

    def self.get_wild(year)
      case year
      when "04", "05", "06"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tccc#{year}&d3=alg_wildcard_analysis"
      when "07"
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tccc07&d3=algorithm&d4=algoWildcard"
      end
    end

    def self.get_qual(year, num)
      case year
      when "04", "05", "06"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc#{year}_qual_#{num}"
      when "07"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc#{year}_qual_rd#{num}"       
      end
    end

    def self.get_regional(type)
      case type
      when "int'l"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc03_int"
      when "ne/se"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc03_nese"
      when "w/mw"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=tccc03_wmw"
      end
    end
  end

  class TCI
    def self.get_link(used_in)
      pat = /^TCI(\s+\d\d|\s+')?(\d\d)\s+(final|semi|round)(?:.*?\s+(\d+\s*[AB]?))?/i
      match = pat.match used_in
      year = match[2]
      type = match[3].downcase
      num = match[4].nil? ? nil : match[4].downcase.gsub(/\s+/, '')
      get year, type, num
    end

    private 

    def self.get(year, type, num)
      case type
      when 'final'
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tci#{year}&d3=champprob"
      when 'semi' 
        "http://www.topcoder.com/tc?module=Static&d1=tournaments&d2=tci#{year}&d3=semiprob#{num}"
      when 'round'
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=invit#{year}_r#{num}"
      end
    end
  end

  class CRPF
    def self.get_link(used_in)
      pat = /^CRPF Charity (finals|round)/i
      match = pat.match used_in
      case match[1].downcase
      when "finals"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=crpf_finals"
      when "round"
        "http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=crpf_rd1"
      end
    end
  end
end


