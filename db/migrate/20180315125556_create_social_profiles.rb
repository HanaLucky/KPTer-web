class CreateSocialProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :social_profiles, comment: "ソーシャルプロファイル" do |t|
      t.references :user, foreign_key: true
      t.string :provider, null: false, comment: "プロバイダー"
      t.string :uid, null: false, comment: "uid"
      t.string :name, comment: "名前"
      t.string :email, comment: "メールアドレス"
      t.string :image_url, comment: "画像URL"
      t.text :auth_info, comment: "認証情報"
      t.timestamps
      t.integer :lock_version, default: 0, null: false
    end
    add_index :social_profiles, [:provider, :uid], unique: true
  end
end
