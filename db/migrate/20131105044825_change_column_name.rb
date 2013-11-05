class ChangeColumnName < ActiveRecord::Migration
  def up
    rename_column :entries, :date, :datetime
  end

  def down
    rename_column :entries, :datetime, :date
  end
end
