require 'fakeweb'

FakeWeb.allow_net_connect = true # allow unregistered connections

module Topcgen
  class SpecWeb
    def initialize(spec_domain, auth_domain)
      @spec_domain = spec_domain
      @auth_domain = auth_domain
      register_clear
    end

    def register_get(relative_url, body, auth = false)
      FakeWeb.register_uri :get, get_url(relative_url, auth), :body => body
    end

    def register_post(relative_url, body, auth = false)
      FakeWeb.register_uri :post, get_url(relative_url, auth), :body => body
    end

    def get_url(relative_url, auth = false)
      (get_domain auth) + relative_url
    end

    def get_domain auth = false
      auth ? @auth_domain : @spec_domain
    end

    def register_clear
      FakeWeb.clean_registry
    end
  end
end
