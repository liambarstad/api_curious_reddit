class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :author
      t.string :image
      t.text :body
      t.string :link
      t.references :subreddit, foreign_key: true

      t.timestamps
    end
  end
end
