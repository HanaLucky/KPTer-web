class ChnageColumnToKpCard < ActiveRecord::Migration[5.2]
  def up
    change_column_null :kp_cards, :owner_id, true
  end

  def down
    change_column_null :kp_cards, :owner_id, false
  end
end
