class EditEntrySchema < ActiveRecord::Migration

  def change
    add_column :entries, :description, :text
    add_column :entries, :guid, :string
  end

end
