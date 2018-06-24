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

ActiveRecord::Schema.define(version: 20180620184259) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cooking_records", force: :cascade do |t|
    t.integer "user_id"
    t.integer "recipe_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "followings", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followee_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "recipe_id"
    t.float "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer "ingredient_id"
    t.integer "recipe_id"
    t.string "note"
    t.float "quantity"
    t.string "quantity_original"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "url"
    t.string "image"
    t.string "cookingMethod"
    t.integer "portions"
    t.integer "author_id"
    t.integer "cookTime"
    t.integer "prepTime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.string "name"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_vector"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "wish_records", force: :cascade do |t|
    t.integer "user_id"
    t.integer "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cooking_records", "recipes", name: "cooking_records_recipes_recipe_id_fk"
  add_foreign_key "cooking_records", "users", name: "cooking_records_users_user_id_fk"
  add_foreign_key "followings", "users", column: "followee_id", name: "followings_users_followee_id_fk"
  add_foreign_key "followings", "users", column: "follower_id", name: "followings_users_follower_id_fk"
  add_foreign_key "ingredients", "users", column: "author_id", name: "ingredients_users_author_id_fk"
  add_foreign_key "ratings", "recipes", name: "ratings_recipes_recipe_id_fk"
  add_foreign_key "ratings", "users", name: "ratings_users_user_id_fk"
  add_foreign_key "recipe_ingredients", "ingredients", name: "recipe_ingredients_ingredients_ingredient_id_fk"
  add_foreign_key "recipe_ingredients", "recipes", name: "recipe_ingredients_recipes_recipe_id_fk"
  add_foreign_key "recipes", "users", column: "author_id", name: "recipes_users_author_id_fk"
  add_foreign_key "wish_records", "recipes", name: "wish_records_recipes_recipe_id_fk"
  add_foreign_key "wish_records", "users", name: "wish_records_users_user_id_fk"
end
