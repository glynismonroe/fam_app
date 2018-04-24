class AddIpToUser < ActiveRecord::Migration
  def change
    add_column :users, :Ip, :float
  end
end
