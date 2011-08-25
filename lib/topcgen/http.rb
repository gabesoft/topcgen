require 'net/https'

module Topcgen
  class HTTP
    def self.get(uri, cookies)
      http = get_http uri

      opts = {}
      opts['Cookie'] = cookies.to_s unless cookies.empty?

      request = Net::HTTP::Get.new uri.request_uri, opts

      http.start.request request
    end

    def self.post(uri, cookies, params = nil)
      params ||= {}
      http = get_http uri

      opts = {}
      opts['Cookie'] = cookies.to_s unless cookies.empty?

      request = Net::HTTP::Post.new uri.request_uri, opts
      request.set_form_data params

      http.request request
    end

    private

    def self.get_http uri
      http = Net::HTTP.new uri.host, uri.port
      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http
    end
  end
end

