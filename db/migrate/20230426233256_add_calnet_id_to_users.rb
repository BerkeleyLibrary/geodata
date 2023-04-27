class AddCalnetIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :calnet_uid, :string    
  end
end
