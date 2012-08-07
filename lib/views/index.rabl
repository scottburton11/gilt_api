collection @products
attributes :id, :name, :description, :url, :sku, :store, :images, :price_cents

node :price do |p|
  p.price
end

node :designer_name do |p|
  p.designer.name
end