Sequel.migration do
  up do
    create_join_table(:category_id => :categories, :product_id => :products)
  end

  down do
    drop_table(:categories_products)
  end
end