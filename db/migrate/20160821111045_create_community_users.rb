class CreateCommunityUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :community_users, comment: "コミュニティ：ユーザー関連" do |t|
      t.references :community, foreign_key: true, null: false, comment: "コミュニティID"
      t.references :user, foreign_key: true, null: false, comment: "ユーザーID"

      t.timestamps
    end
    add_index :community_users, [:community_id, :user_id], unique: true
  end
end
