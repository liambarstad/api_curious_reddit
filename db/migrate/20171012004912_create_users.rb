class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :link_karma
      t.integer :comment_karma

      t.timestamps
    end
  end
end
