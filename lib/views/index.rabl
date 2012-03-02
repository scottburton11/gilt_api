collection @products
attributes :id, :name, :description, :url, :sku, :category

code :image_url do |p|
  p.image_file_path
end

code :price do |p|
  p.price
end

code :designer_name do |p|
  p.designer.name
end