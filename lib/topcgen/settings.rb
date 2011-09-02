
module Topcgen
  class Settings
    def self.read_file(file)
      if !!file && (File.exists? file)
        File.open(file, 'r') do |stream|
          read stream
        end
      else
        {}
      end
    end

    def self.read(stream)
      stream.rewind
      clean(YAML::load stream.read)
    end

    private

    def self.clean(hash) 
      hash.inject({}) do |memo,(k,v)|
        if v.instance_of?(Hash)
          memo[k.to_sym] = clean v
        elsif v.instance_of?(Array)
          memo[k.to_sym] = v.map { |e| clean e }
        else
          memo[k.to_sym] = v
        end
        memo 
      end
    end
  end
end
