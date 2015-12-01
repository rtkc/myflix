class ChangeOrdertoPosition < ActiveRecord::Migration
  def change
    rename_column :queue_items, :order, :position
  end
end
