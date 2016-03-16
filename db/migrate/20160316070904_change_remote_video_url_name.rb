class ChangeRemoteVideoUrlName < ActiveRecord::Migration
  def change
    rename_column :videos, :remote_video_url, :video_url
  end
end
