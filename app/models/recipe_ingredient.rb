class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  def tf_idf
    tf = quantity
    df = RecipeIngredient.where(ingredient_id: ingredient_id).count
    n = Recipe.count
    idf = Math.log(n / df)
    tf * idf
  end
end
