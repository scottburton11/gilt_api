require 'gilt'
require 'sinatra'


class Gilt::Products < Sinatra::Base

  # options "/products" do
  #   headers "Access-Control-Allow-Origin" => "*",
  #           "Access-Control-Allow-Headers" => "Content-Type"
  # end

  set :public_folder, File.dirname(__FILE__) + '/static'

  get "/products" do
    @products = Product.paginate(params).all
    total_pages = Product.total_pages(params[:per_page])
    headers "X-Pagination" => "page: #{params[:page]}, per_page: #{params[:per_page]}, next_page: #{[(params[:page].to_i + 1), total_pages].min}, total_pages: #{total_pages}"
    render :rabl, :index, :format => "json"
  end

  get "/products/:id" do
    @product = Product.find(id: params[:id])
    content_type :json
    @product.to_json
  end
end
