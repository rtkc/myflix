class AddColumnRemoteVideoUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :remote_video_url, :string
  end
end
