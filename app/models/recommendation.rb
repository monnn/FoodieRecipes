module Recommendation
  extend Calculations

  # Content base filtering, based on recipes ingredients
  # Uses user_vector and returns recipes with most similar ingredients vector
  def self.content_based_recommendation(user, n, recipes_collection = Recipe.all)
    recipes_with_similarity = []

    recipes_collection.each do |recipe|
      recipe_similarity = Calculations.cosine_similarity(user.user_vector, recipe.ingredients_vector)
      recipes_with_similarity.push(recipe[:id] => recipe_similarity)
    end

    sorted_recipes = recipes_with_similarity.sort_by! { |recipe| -recipe.values.first }
    sorted_recipes[0, n].map { |recipe_with_similarity| Recipe.find(recipe_with_similarity.keys.first) }
  end

  # Social based recommendations - Returns recipes, added within user network,
  # sorted by user trust in author and overwall recipe rating.
  def self.social_based_recommendation(user, n)
    recipes_with_weight = []

    user.most_trusted_followings.each do |following|
      followee = following.followee
      followee.added_recipes.each do |recipe|
        recipe_weight = recipe.rating + (following.trust * 5)
        recipes_with_weight.push(recipe[:id] => recipe_weight)
      end
    end

    sorted_recipes = recipes_with_weight.sort_by! { |recipe| -recipe.values.first }
    sorted_recipes[0, n].map { |recipe_with_weight| Recipe.find(recipe_with_weight.keys.first) }
  end

  # User - User Collaborative Filtering - Returns recipes, which are most likely to be liked by user,
  # according to ratings given from other users with similar taste.
  def self.user_based_recommendation(user, n)
    k_nearest_neighbours = user.k_nearest_neighbours(n)
    recipes_with_rating = []

    not_rated_recipes = Recipe.all.to_a.reject { |recipe| recipe.rated_by?(user) }

    not_rated_recipes.each do |recipe|
      recipe_rating = recipe_prediction_rating(recipe, k_nearest_neighbours)
      recipes_with_rating.push(recipe[:id] => recipe_rating)
    end

    sorted_recipes = recipes_with_rating.sort_by! { |recipe| -recipe.values.first }
    sorted_recipes[0, n].map { |recipe_with_rating| Recipe.find(recipe_with_rating.keys.first) }
  end

  def self.recipe_prediction_rating(recipe, k_nearest_neighbours)
    all_recipe_ratings = []

    k_nearest_neighbours.each do |neighbour|
      user_rating = Rating.find_by(user_id: neighbour.keys.first, recipe_id: recipe[:id])
      next if user_rating.nil?

      recipe_rating = ((user_rating[:rating] * 5) + neighbour.values.first) / 5
      all_recipe_ratings.push(recipe_rating)
    end

    return 0 if all_recipe_ratings.empty?

    all_recipe_ratings.sum / all_recipe_ratings.size.to_f
  end
end
