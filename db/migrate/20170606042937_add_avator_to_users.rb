class AddAvatorToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar, :string, after: :username
  end
end
