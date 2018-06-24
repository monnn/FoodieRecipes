class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :recipe_id
      t.float :rating

      t.timestamps
    end

    add_foreign_key :ratings, :users,
                    column: :user_id,
                    name: :ratings_users_user_id_fk

    add_foreign_key :ratings, :recipes,
                    column: :recipe_id,
                    name: :ratings_recipes_recipe_id_fk
  end
end
