class ChangeColumnAuthorToUserid < ActiveRecord::Migration
  def change
    add_column :reviews, :user_id, :integer
    remove_column :reviews, :author, :string
  end
end