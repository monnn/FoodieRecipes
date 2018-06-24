class User < ApplicationRecord
  extend Calculations

  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  serialize :user_vector, Array
  after_create :assign_user_role

  has_many :added_recipes,
           class_name: 'Recipe',
           foreign_key: :author_id

  has_many :followings,
           foreign_key: :follower_id

  has_many :ratings

  has_many :cooking_records

  has_many :wish_records

  ROLES = {
    ADMIN: 'admin',
    USER: 'user'
  }.freeze

  def admin?
    role.eql?(ROLES[:ADMIN])
  end

  def assign_user_role
    return unless role.nil?

    self.role = ROLES[:USER]
  end

  def update_user_vector(rating = nil)
    current_user_vector = user_vector || []
    rating_value = rating[:rating]
    return if rating_value < 3

    ingredients = rating.recipe.ingredients_vector

    ingredients.each do |ingredient|
      new_weight = (ingredient.values.first * rating_value) / 5

      existing_ingredient = current_user_vector.select { |user_vector_ingredient| user_vector_ingredient[ingredient] }

      if existing_ingredient.empty?
        current_user_vector.push("#{ingredient.keys.first}": new_weight)
        next
      end

      current_user_vector = current_user_vector.map do |user_vector_ingredient|
        user_vector_ingredient[ingredient] + new_weight if user_vector_ingredient[ingredient]
      end
    end

    update(user_vector: current_user_vector)
  end

  def ratings_vector
    recipes_ratings = []

    ratings.each do |rating|
      recipes_ratings.push(rating[:recipe_id] => rating[:rating])
    end

    recipes_ratings
  end

  def most_trusted_followings
    followings.to_a.sort_by! { |following| -following.trust }
  end

  # k_nearest_neighbours in user item rating matrix
  def k_nearest_neighbours(k)
    other_users = User.where.not(id: id)
    users_with_similarity = []

    other_users.each do |other_user|
      user_similarity = Calculations.pearson_correlation(ratings_vector, other_user.ratings_vector)
      users_with_similarity.push(other_user[:id] => user_similarity)
    end

    users_with_similarity.to_a.sort_by! { |user_with_similarity| -user_with_similarity.values.first }[0, k]
  end
end
