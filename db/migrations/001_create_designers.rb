Sequel.migration do
  up do
    create_table(:designers) do
      primary_key :id
      String :name
    end
  end

  down do
    drop_table(:designers)
  end
end