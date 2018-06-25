class UsersController < ApplicationController
  before_action :set_users, only: [:index]
  before_action :set_user

  def index
    render 'users'
  end

  def edit_user
    render 'edit_user'
  end

  def show
    render 'user'
  end

  def update
    if @user.update(user_params)
      render 'user', notice: 'User was successfully updated.'
    else
      render 'users', status: :unprocessable_entity
    end
  end

  def follow_user
    @following = Following.new(follower_id: current_user.id, followee_id: params[:id])

    if @following.save
      render 'user', notice: 'User was successfully updated.'
    else
      render 'users', status: :unprocessable_entity
    end
  end

  def content_based_recommendations
    if params[:ingredients]
      recipe_ingedients = RecipeIngedient.where(ingredient_id: params[:ingredients]).to_a
      recipes_collection = recipe_ingedients.map(&:recipe)
    else
      recipes_collection = Recipe.all
    end

    @recipes = Recommendation.content_based_recommendation(@user, 10, recipes_collection)
    render 'recipes'
  end

  def social_recommendations
    @recipes = Recommendation.social_based_recommendation(@user, 10)
    render 'recipes'
  end

  def user_based_recommendations
    @recipes = Recommendation.user_based_recommendation(@user, 10)
    render 'recipes'
  end

  def mixed_recommendations
    content_based = Recommendation.content_based_recommendation(@user, 7)
    user_based = Recommendation.user_based_recommendation(@user, 3)
    @recipes = content_based + user_based
    render 'recipes'
  end

  def ratings
    @ratings = Rating.where(user_id: @user[:id])
    render 'ratings'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_users
    @users = User.all
  end

  def user_params
    params.require(:user).permit(:user_id, :recipe_id)
  end
end
