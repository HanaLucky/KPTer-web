class AddLockVersionToKpCards < ActiveRecord::Migration[5.0]
  def change
    add_column :kp_cards, :lock_version, :integer, default: 0, null: false, after: :updated_at
  end
end
