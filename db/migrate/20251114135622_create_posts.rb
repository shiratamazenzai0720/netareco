class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :name
      t.string :title
      t.text :body
      t.string :tag
      t.timestamps
    end
  end
end