class Recipe < ApplicationRecord
  include Calculations

  has_many :ratings
  has_many :cooking_records
  has_many :wish_records

  def self.highest_rated(n)
    Recipe.all.sort_by(&:rating).reverse[0, n]
  end

  def rating
    all_ratings = Rating.where(recipe_id: id).map(&:rating)
    return 0.0 if all_ratings.empty?

    all_ratings.sum / all_ratings.size.to_f
  end

  def ingredients_vector
    recipe_ingredients = RecipeIngredient.where(recipe_id: id)
    ingredients_with_weight = []

    recipe_ingredients.each do |recipe_ingredient|
      ingredients_with_weight.push(recipe_ingredient.ingredient[:name] => recipe_ingredient.tf_idf)
    end

    ingredients_with_weight
  end

  def ingredients
    RecipeIngredient.where(recipe_id: id)
  end

  def similar_recipes(n)
    other_recipes = Recipe.where.not(id: id)
    recipes_with_similarity = []

    other_recipes.each do |recipe|
      similarity = cosine_similarity(ingredients_vector, recipe.ingredients_vector)
      recipes_with_similarity.push(recipe[:name] => similarity)
    end

    recipes_with_similarity.sort_by! { |recipe| -recipe.values.first }[0, n]
  end

  def contains_ingredient(ingredient_id)
    RecipeIngredient.exists?(recipe_id: id, ingredient_id: ingredient_id)
  end

  def rated_by?(user)
    Rating.exists?(user_id: user[:id], recipe_id: id)
  end
end
