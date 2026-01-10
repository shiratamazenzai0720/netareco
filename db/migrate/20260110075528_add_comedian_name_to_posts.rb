class AddComedianNameToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :comedian_name, :string
  end
end
