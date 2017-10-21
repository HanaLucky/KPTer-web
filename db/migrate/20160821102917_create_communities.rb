class CreateCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :communities, comment: "コミュニティ" do |t|
      t.string :name, limit: 32, null: false, comment: "コミュニティ名"

      t.timestamps
    end
  end
end
