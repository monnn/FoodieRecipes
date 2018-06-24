class CreateCookingRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :cooking_records do |t|
      t.integer :user_id
      t.integer :recipe_id
      t.date :date

      t.timestamps
    end

    add_foreign_key :cooking_records, :users,
                    column: :user_id,
                    name: :cooking_records_users_user_id_fk

    add_foreign_key :cooking_records, :recipes,
                    column: :recipe_id,
                    name: :cooking_records_recipes_recipe_id_fk
  end
end
