# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180321043855) do

  create_table "boards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ボード" do |t|
    t.integer  "community_id",             null: false, comment: "コミュニティID"
    t.string   "name",                     null: false, comment: "ボード名"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "lock_version", default: 0, null: false
    t.index ["community_id"], name: "index_boards_on_community_id", using: :btree
  end

  create_table "communities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "コミュニティ" do |t|
    t.string   "name",         limit: 32,             null: false, comment: "コミュニティ名"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "lock_version",            default: 0, null: false
  end

  create_table "community_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "コミュニティ：ユーザー関連" do |t|
    t.integer  "community_id",                                 null: false, comment: "コミュニティID"
    t.integer  "user_id",                                      null: false, comment: "ユーザーID"
    t.string   "status",       limit: 16, default: "inviting", null: false, comment: "ステータス"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "lock_version",            default: 0,          null: false
    t.index ["community_id", "user_id"], name: "index_community_users_on_community_id_and_user_id", unique: true, using: :btree
    t.index ["community_id"], name: "index_community_users_on_community_id", using: :btree
    t.index ["user_id"], name: "index_community_users_on_user_id", using: :btree
  end

  create_table "kp_cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "KPカード" do |t|
    t.integer  "board_id",                             null: false, comment: "ボードID"
    t.integer  "owner_id",                             null: false, comment: "カード作成者ID"
    t.string   "title",                                             comment: "タイトル"
    t.string   "detail",       limit: 512,                          comment: "詳細"
    t.string   "card_type",    limit: 16,              null: false, comment: "カード種別"
    t.integer  "x",                        default: 0, null: false, comment: "X座標"
    t.integer  "y",                        default: 0, null: false, comment: "Y座標"
    t.integer  "order",                    default: 0,              comment: "重ね順"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "lock_version",             default: 0, null: false
    t.index ["board_id"], name: "index_kp_cards_on_board_id", using: :btree
    t.index ["card_type"], name: "index_kp_cards_on_card_type", using: :btree
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "likable_type"
    t.integer  "likable_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["likable_type", "likable_id"], name: "index_likes_on_likable_type_and_likable_id", using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "memos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "メモ" do |t|
    t.integer  "board_id",                               null: false, comment: "ボードID"
    t.text     "contents",     limit: 65535,                          comment: "内容"
    t.integer  "x",                          default: 0, null: false, comment: "X座標"
    t.integer  "y",                          default: 0, null: false, comment: "Y座標"
    t.integer  "order",                      default: 0,              comment: "重ね順"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "lock_version",               default: 0, null: false
    t.index ["board_id"], name: "index_memos_on_board_id", using: :btree
  end

  create_table "social_profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ソーシャルプロファイル" do |t|
    t.integer  "user_id"
    t.string   "provider",                               null: false, comment: "プロバイダー"
    t.string   "uid",                                    null: false, comment: "uid"
    t.string   "name",                                                comment: "名前"
    t.string   "email",                                               comment: "メールアドレス"
    t.string   "image_url",                                           comment: "画像URL"
    t.text     "auth_info",    limit: 65535,                          comment: "認証情報"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "lock_version",               default: 0, null: false
    t.index ["provider", "uid"], name: "index_social_profiles_on_provider_and_uid", unique: true, using: :btree
    t.index ["user_id"], name: "index_social_profiles_on_user_id", using: :btree
  end

  create_table "t_cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "Tカード" do |t|
    t.integer  "board_id",                                  null: false, comment: "ボードID"
    t.integer  "owner_id",                                  null: false, comment: "カード作成者ID"
    t.string   "title",                                                  comment: "タイトル"
    t.string   "detail",       limit: 512,                               comment: "詳細"
    t.date     "deadline",                                               comment: "期限"
    t.string   "status",       limit: 16,  default: "open", null: false, comment: "ステータス"
    t.integer  "x",                        default: 0,      null: false, comment: "X座標"
    t.integer  "y",                        default: 0,      null: false, comment: "Y座標"
    t.integer  "order",                    default: 0,                   comment: "重ね順"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "lock_version",             default: 0,      null: false
    t.index ["board_id"], name: "index_t_cards_on_board_id", using: :btree
    t.index ["status"], name: "index_t_cards_on_status", using: :btree
  end

  create_table "tcard_assignees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "Tカード担当者" do |t|
    t.integer  "user_id",                               comment: "ユーザーID"
    t.integer  "t_card_id",                             comment: "TカードID"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "lock_version", default: 0, null: false
    t.index ["t_card_id"], name: "index_tcard_assignees_on_t_card_id", using: :btree
    t.index ["user_id", "t_card_id"], name: "index_tcard_assignees_on_user_id_and_t_card_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_tcard_assignees_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "email",                              default: "",    null: false
    t.string   "encrypted_password",                 default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "nickname",                limit: 32,                 null: false
    t.string   "avatar"
    t.datetime "created_at",                                         null: false
    t.boolean  "only_oauth_registration",            default: false, null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "lock_version",                       default: 0,     null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "boards", "communities"
  add_foreign_key "community_users", "communities"
  add_foreign_key "community_users", "users"
  add_foreign_key "kp_cards", "boards"
  add_foreign_key "likes", "users"
  add_foreign_key "memos", "boards"
  add_foreign_key "social_profiles", "users"
  add_foreign_key "t_cards", "boards"
  add_foreign_key "tcard_assignees", "t_cards"
  add_foreign_key "tcard_assignees", "users"
end
