require 'fakeweb'

FakeWeb.allow_net_connect = true # allow unregistered connections

module Topcgen
  SPEC_DOMAIN = 'http://www.myapp.com/'
  AUTH_DOMAIN = 'https://www.myapp.com/'

  class SpecWeb
    def self.register_get(relative_url, body, auth = false)
      FakeWeb.register_uri :get, get_url(relative_url, auth), :body => body
    end

    def self.register_post(relative_url, body, auth = false)
      FakeWeb.register_uri :post, get_url(relative_url, auth), :body => body
    end

    def self.get_url(relative_url, auth = false)
      (get_domain auth) + relative_url
    end

    def self.get_domain auth = false
      auth ? AUTH_DOMAIN : SPEC_DOMAIN
    end

    def self.register_clear
      FakeWeb.clean_registry
    end
  end
end
