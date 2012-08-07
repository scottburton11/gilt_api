Sequel.migration do
  up do
    alter_table(:products) do
      rename_column :category, :store
      add_index :store
    end
  end

  down do
    alter_table(:products) do
      rename_column :store, :category
      drop_index :store
    end
  end
end