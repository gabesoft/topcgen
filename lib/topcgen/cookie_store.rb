require 'delegate'
require 'webrick/cookie'

require 'yaml'

class WEBrick::Cookie
  def expired?
    !!expires && expires < Time.now
  end
end

module Topcgen
  class CookieStore < DelegateClass(Hash)

    def initialize(cookies = nil)
      @cookies = {}
      cookies.each { |name, value| @cookies[name] = WEBrick::Cookie.new(name, value) } if cookies
      super(@cookies)
    end

    def merge!(set_cookie_str)
      begin
        cookie_hash = WEBrick::Cookie.parse_set_cookies(set_cookie_str).inject({}) do |hash, cookie|
          add_cookie cookie, hash
          hash
        end
        @cookies.merge! cookie_hash
      rescue
      end
    end

    def add_cookie(cookie, hash = nil)
      hash ||= @cookies
      hash[cookie.name] = cookie if !!cookie
    end

    def to_s
      @cookies.values.
        reject { |cookie| cookie.expired? }.
        map { |cookie| "#{cookie.name}=#{cookie.value}" }.join(';')
    end

  end

  class CookieStoreSerializer

    def self.file_save(file, cookies)
      if !!file
        File.open(file, 'w') do |stream| 
          save stream, cookies 
        end
      end
    end

    def self.file_load(file)
      if !!file && (File.exists? file)
        File.open(file, 'r') do |stream|
          load stream
        end
      else
        CookieStore.new
      end
    end

    def self.save(stream, cookies)
      stream << cookies.to_yaml
    end

    def self.load(stream)
      stream.rewind
      store = CookieStore.new
      hash = YAML::load stream.read
      hash.each { |name, value| store.add_cookie value }
      store
    end

  end
end
