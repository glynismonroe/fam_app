class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :LONGBLOB
  end
end
