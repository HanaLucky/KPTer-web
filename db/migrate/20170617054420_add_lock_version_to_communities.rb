class AddLockVersionToCommunities < ActiveRecord::Migration[5.0]
  def change
    add_column :communities, :lock_version, :integer, default: 0, null: false, after: :updated_at
  end
end
