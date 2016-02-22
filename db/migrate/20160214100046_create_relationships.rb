class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :leader_user_id, :follower_user_id
      t.timestamps
    end
  end
end
