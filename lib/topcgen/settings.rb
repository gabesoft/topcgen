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
      sym_keys(YAML::load stream.read)
    end

    private

    def self.sym_keys(hash) 
      hash.inject({}) do |memo,(k,v)|
        if v.instance_of?(Hash)
          memo[k.to_sym] = sym_keys v
        elsif v.instance_of?(Array)
          memo[k.to_sym] = v.map { |e| sym_keys e }
        else
          memo[k.to_sym] = v
        end
        memo 
      end
    end
  end
end
