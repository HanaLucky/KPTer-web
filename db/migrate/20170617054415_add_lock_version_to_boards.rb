class AddLockVersionToBoards < ActiveRecord::Migration[5.0]
  def change
    add_column :boards, :lock_version, :integer, default: 0, null: false, after: :updated_at
  end
end
