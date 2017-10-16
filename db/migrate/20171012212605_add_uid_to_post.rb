class AddUidToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :uid, :string
  end
end
