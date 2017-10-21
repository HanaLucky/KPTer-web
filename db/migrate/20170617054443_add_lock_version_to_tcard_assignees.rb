class AddLockVersionToTcardAssignees < ActiveRecord::Migration[5.0]
  def change
    add_column :tcard_assignees, :lock_version, :integer, default: 0, null: false, after: :updated_at
  end
end
