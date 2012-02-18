Sequel.migration do
  up do
    alter_table(:products) do
      add_column :category, String
      add_index :category
    end
  end

  down do
    alter_table(:products) do
      remove_column :category
    end
  end
end