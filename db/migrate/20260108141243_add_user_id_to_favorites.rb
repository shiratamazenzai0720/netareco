class AddUserIdToFavorites < ActiveRecord::Migration[6.1]
  def change
    add_column :favorites, :user_id, :integer
    add_index :favorites, :user_id
  end
end
