class AddOnlyOAuthRegistrationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :only_oauth_registration, :boolean, default: 0, null: false, after: :created_at
  end
end
