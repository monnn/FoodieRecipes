class Ingredient < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def recipe_presence_count
    RecipeIngredient.where(ingredient_id: id).count
  end

  def self.by_name(ingredient_name)
    Ingredient.where(name: ingredient_name)
  end
end
