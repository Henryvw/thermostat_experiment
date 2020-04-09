class RenameSequentialNumberToSequentialId < ActiveRecord::Migration[6.0]
  def change
    rename_column :readings, :sequential_number, :sequential_id
  end
end
