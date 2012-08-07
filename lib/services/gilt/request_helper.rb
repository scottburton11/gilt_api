require 'net/http'

module Gilt
  module RequestHelper
    def response(uri)
      http(uri).request(request(uri))
    end

    def http(uri)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => true)
    end

    def request(uri)
      Net::HTTP::Get.new(uri.request_uri)
    end

  end
end
