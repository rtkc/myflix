class ChangeCommentsColumnNameToReview < ActiveRecord::Migration
  def change
    rename_column :reviews, :comment, :review
  end
end
