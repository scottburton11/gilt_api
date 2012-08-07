require 'json'
require 'ostruct'

module Gilt
  class Sale
    extend Gilt::RequestHelper
    def self.all
      JSON.parse(response(uri).body)['sales'].map{ |attrs| new(attrs) }
    end

    attr_accessor :name, :sale, :sale_key, :store, :sale_url, :image_urls, :begins, :ends, :description

    def initialize(attributes={})
      attributes.each_pair do |key, value|
        self.send("#{key}=".to_sym, value)
      end
      self
    end

    attr_writer :products
    def products
      @products || []
    end

    def self.uri
      URI.parse("https://api.gilt.com/v1/sales/active.json?apikey=#{ENV['GILT_API_KEY']}")
    end
  end
end
