class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :author_id

      t.timestamps
    end

    add_foreign_key :ingredients, :users,
                    column: :author_id,
                    name: :ingredients_users_author_id_fk
  end
end
