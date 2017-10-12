class CreateSubreddits < ActiveRecord::Migration[5.1]
  def change
    create_table :subreddits do |t|
      t.string :title
      t.string :subtitle
      t.text :description
      t.string :image_path
      t.string :uid

      t.timestamps
    end
  end
end
