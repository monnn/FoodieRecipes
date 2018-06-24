class CreateRecipeIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :recipe_ingredients do |t|
      t.integer :ingredient_id
      t.integer :recipe_id
      t.string :note
      t.float :quantity # in grams
      t.string :quantity_original

      t.timestamps
    end

    add_foreign_key :recipe_ingredients, :ingredients,
                    column: :ingredient_id,
                    name: :recipe_ingredients_ingredients_ingredient_id_fk

    add_foreign_key :recipe_ingredients, :recipes,
                    column: :recipe_id,
                    name: :recipe_ingredients_recipes_recipe_id_fk
  end
end
