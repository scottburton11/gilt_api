require 'net/http'
require 'pathname'
require 'uri'

class Product < Sequel::Model

  many_to_one :designer
  many_to_many :categories

  def self.paginate(params = {})
    limit = (params[:per_page] || 20).to_i
    page = (params[:page] || 1).to_i
    offset = limit * (page - 1)
    eager(:designer).limit(limit, offset).filter(:store => params[:store])
  end

  def self.total_pages(per_page=20)
    per_page ||= 20
    (count.to_f / per_page.to_i).ceil
  end

  def designer_name=(name)
    self.designer = Designer.find_or_create(:name => name)
  end

  def image_versions
    {
      :small  => {:name => "300x400", :width => 300, :height => 400},
      :medium => {:name => "420x560", :width => 420, :height => 560},
      :large  => {:name => "1080x1440", :width => 1080, :height => 1440}
    }
  end

  def image_pathname
    Pathname.new image_path
  end

  def images(format = :jpg)
    image_versions.inject({}) {|m, i| i[1][:path] = image_version_path(i[0], format).to_s ; m[i[0]] = i[1]; m }
  end

  def image_version_path(version = :small, format = :jpg)
    "/#{image_pathname.dirname}/#{image_versions[version][:name]}.#{format}"
  end

  def price
    "$#{price_cents/100}"
  end

end