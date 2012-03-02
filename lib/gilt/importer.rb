require 'nokogiri'
require 'open-uri'
require 'cgi'

module Gilt
  module Website
    ProductSelector = "article.look.available"
  end
end

class Importer
  attr_reader :urls
  def initialize(*urls)
    @urls = urls
  end

  def perform
    urls.each {|url| ProductsImportJob.new(url).perform }
  end

  class ProductsImportJob

    attr_reader :url
    def initialize(url)
      @url = url
    end

    def perform
      begin
        products.each {|product| create(ProductImport.new(product).attributes)}
      rescue => e
        puts "Error: #{e}"
      end
    end

    def products
      document.css(Gilt::Website::ProductSelector)
    end

    def categories
      query["utm_campaign"][0].split(",")
    end

    private

    def create(attributes)
      begin
        Product.create attributes.merge(:category => categories.first)
      rescue Sequel::DatabaseError
      end
    end

    def query
      CGI.parse parsed_url.query
    end

    def parsed_url
      @parsed_url ||= URI.parse(url)
    end

    def response_body
      @reponse_body ||= open(url)
    end

    def document
      @document ||= Nokogiri::HTML(response_body)
    end
  end

  class ProductImport < Struct.new(:fragment)

    # def inspect
    #   "ProductImport: #{attributes.map {|a| "#{a[0]}: #{a[1]}"}}"
    # end

    def attributes
      {
        image_url: image_url,
        designer_name: designer_name,
        name: name,
        price_cents: (price_string.to_f * 100).to_i,
        url: url,
        sku: sku.to_i
      }
    end

    def image_url
      self[:fragment].css(".photo").first.attributes['src'].value
    end

    def designer_name
      self[:fragment].css("header .brand-name").first.content
    end

    def name
      self[:fragment].css("header .product-name").first.content
    end

    def price_string
      price_from_string(self[:fragment].css("header .price .sale-price").first.content)
    end

    def url
      self[:fragment].css(".look-photo").first.attributes["href"].value
    end

    def sku
      self[:fragment].css("form.sku-selection").first.attributes["data-gilt-product-id"].content
    end

    private

    def price_from_string(str)
      str.match(/[\d\.]+/)[0]
    end

  end
end
