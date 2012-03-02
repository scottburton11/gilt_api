require 'net/http'
require 'pathname'
require 'uri'

class Product < Sequel::Model

  many_to_one :designer

  def self.paginate(params = {})
    limit = (params[:per_page] || 20).to_i
    page = (params[:page] || 1).to_i
    offset = limit * (page - 1)
    eager_graph(:designer).limit(limit, offset).where(:category => params[:category])
  end

  def self.total_pages(per_page=20)
    (count.to_f / per_page.to_i).ceil
  end

  def designer_name=(name)
    self.designer = Designer.find_or_create(:name => name)
  end

  def price
    # "$%.2f" % (price_cents.to_f/100)
    "$#{price_cents/100}"
  end

  def save_image_file
    make_image_path
    File.open(image_file_full_path, "w+") do |file|
      file.write Net::HTTP.get(remote_image_url)
    end
  end

  def medium
    "300x400.jpg"
  end

  def large
    "420x560.jpg"
  end

  def image_file_path
    image_path.to_s
  end

  def image_file_full_path(version = :medium)
    full_path_to_public + image_path.to_s
  end

  def full_path_to_public
    File.expand_path(File.join(File.expand_path(__FILE__), "..", "..", "public"))
  end

  def make_image_path
    Pathname.new(image_file_full_path).dirname.mkpath
  end

  def image_path
    @image_path ||= Pathname.new(remote_image_url.path)
  end

  def remote_image_url
    URI.parse(image_url)
  end

  def to_json(*args)
    values.merge(image_url: image_file_path, price: price, designer_name: designer.name).to_json(*args)
  end
end