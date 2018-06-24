class CreateWishRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :wish_records do |t|
      t.integer :user_id
      t.integer :recipe_id

      t.timestamps
    end

    add_foreign_key :wish_records, :users,
                    column: :user_id,
                    name: :wish_records_users_user_id_fk

    add_foreign_key :wish_records, :recipes,
                    column: :recipe_id,
                    name: :wish_records_recipes_recipe_id_fk
  end
end
