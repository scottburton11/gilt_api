Sequel.migration do
  up do
    create_table(:products) do
      primary_key :id
      foreign_key :designer_id
      String :name
      String :description, :text => true
      String :image_path
      String :url
      Integer :sku
      Integer :price_cents
    end
  end

  down do
    drop_table(:products)
  end
end