class ChangeNicknameToUser < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :nickname, :string, limit: 32
  end
  def down
    change_column :users, :nickname, :string, limit: 255
  end
end
