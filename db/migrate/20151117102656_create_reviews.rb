class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :video_id
      t.integer :rating
      t.string :author
      t.text :comment
      t.timestamps
    end
  end
end