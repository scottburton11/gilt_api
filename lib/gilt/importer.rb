require 'fileutils'
require 'pry'

module Gilt
  class Importer

    module ImageHelper 
      def image_path(uri)
        uri = URI.parse(uri) unless uri.respond_to?(:path)
        Pathname.new(uri.path.to_s.sub(/^\//, ""))
      end
    end

    def self.import
      new.perform
    end

    def perform
      sales.each do |sale|
        sale.products.each do |url|

          begin
            product = ProductImporter.import(url, sale)  
          rescue => e
            binding.pry
          end
          
          image_importer = ImageImporter.import(product.response)
        end
      end
    end

    def sales
      @sales ||= Gilt::Sale.all
    end

    class ProductImporter
      include Gilt::Importer::ImageHelper

      def self.import(url, sale)
        importer = new(url, sale)
        importer.perform
        importer
      end

      attr_reader :url, :sale
      attr_accessor :product
      def initialize(url, sale = nil)
        @url, @sale = url, sale
      end

      def response
        @response ||= Gilt::Product.find(url)
      end

      def attributes
        {
         :name => response.name,
         :description => response.content['description'],
         :url => response.sale_url,
         :designer_name => response.brand,
         :store => sale.store,
         :sku => response.skus[0]['id'],
         :price_cents => response.skus[0]['sale_price'].to_i * 100,
         :url => response.product,
         :image_path => image_path(response.image_urls["91x121"][0]["url"])
        }
      end

      def perform
        self.product = ::Product.create attributes
        categorize
        product
      end

      def categorize
        response.categories.uniq.each do |name| 
          product.add_category Category.find_or_create(:name => name)
        end
      end
    end

    class ImageImporter
      include Gilt::Importer::ImageHelper

      def self.import(product)
        importer = new(product)
        importer.perform
        importer
      end

      attr_reader :product
      def initialize(product)
        @product = product  
      end

      def perform
        image_urls.each do |url|
          uri = URI.parse(url)
          full_path = Gilt.root + "lib" + "public" + image_path(url)
          FileUtils.mkdir_p full_path.dirname
          begin
            File.open(full_path, "w+") do |file|
              file.write Net::HTTP.get(uri)
            end
          rescue
          end
        end
      end

      def image_urls
        ["300x400", "420x560", "1080x1440"].map {|size| product.image_urls[size][0]["url"] }
      end
    end
  end
end