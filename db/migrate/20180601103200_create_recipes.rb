class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :image
      t.string :cookingMethod
      t.integer :portions
      t.integer :author_id
      t.integer :cookTime # in minutes
      t.integer :prepTime # in minutes

      t.timestamps
    end

    add_foreign_key :recipes, :users,
                    column: :author_id,
                    name: :recipes_users_author_id_fk
  end
end
