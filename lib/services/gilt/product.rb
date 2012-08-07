require 'json'
require 'ostruct'

module Gilt
  class Product < OpenStruct
    extend Gilt::RequestHelper

    def self.find(url)
      uri = URI(url + "?apikey=#{ENV['GILT_API_KEY']}")
      new JSON.parse(response(uri).body)
    end
  end
end
