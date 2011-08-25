
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
        memo[k.to_sym] = v.instance_of?(Hash) ? (clean v) : v
        memo 
      end
    end
  end
end
