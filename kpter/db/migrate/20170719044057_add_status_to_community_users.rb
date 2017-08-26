class AddStatusToCommunityUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :community_users, :status, :string, limit: 16, null: false, default: CommunityUser.status.inviting, comment: "ステータス", after: :user_id
  end
end
