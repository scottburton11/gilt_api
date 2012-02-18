Sequel.migration do
  up do
    alter_table(:products) do
      add_index :sku, :unique => true
    end
  end

  down do
    alter_table(:products) do
      remove_index :sku
    end
  end
end