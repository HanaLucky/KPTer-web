class CreateCommunityUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :community_users, comment: "コミュニティ：ユーザー関連" do |t|
      t.references :community, foreign_key: true, null: false, comment: "コミュニティID"
      t.references :user, foreign_key: true, null: false, comment: "ユーザーID"

      t.timestamps
    end
  end
end
