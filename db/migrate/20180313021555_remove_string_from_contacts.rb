class RemoveStringFromContacts < ActiveRecord::Migration[5.1]
  def change
    remove_column :contacts, :string, :string
  end
end
