
module Topcgen
  class Settings
    def self.read_file(file)
      if !!file
        File.open(file, 'r') do |stream|
          read stream
        end
      else
        {}
      end
    end

    def self.read(stream)
      stream.rewind
      YAML::load stream.read
    end
  end
end
