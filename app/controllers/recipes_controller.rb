class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :rate_recipe, :cook_recipe]
  before_action :set_recipes, only: [:recipes, :rate_recipe, :cook_recipe]

  before_action :set_cooking_records, only: [:cooking_records, :cook_recipe, :uncook_recipe]
  before_action :set_cooking_record, only: [:uncook_recipe]

  before_action :set_wish_records, only: [:wishlist]
  before_action :set_wish_record, only: [:remove_from_wishlist]

  def recipes
    render 'recipes'
  end

  def show
    render 'recipe'
  end

  def rate_recipe
    @rating = Rating.new(
      user_id: current_user.id,
      recipe_id: @recipe.id,
      rating: recipe_rating_params[:rating]
    )

    if @rating.save
      render 'recipes', notice: t('page_notices.rating_success')
    else
      render 'recipes', status: :unprocessable_entity
    end
  end

  def cooking_records
    render 'cooking_records'
  end

  def cook_recipe
    @cooking_record = CookingRecord.new(
      user_id: current_user.id,
      recipe_id: @recipe.id,
      date: cooking_record_params[:date]
    )

    if @cooking_record.save
      render 'cooking_records', notice: t('page_notices.cooking_record_create_success')
    else
      render 'cooking_records', status: :unprocessable_entity
    end
  end

  def uncook_recipe
    @cooking_record.destroy
    render 'cooking_records', notice: t('page_notices.cooking_record_destroy_success')
  end

  def wishlist
    render 'wish_records'
  end

  def add_to_wishlist
    @wish_record = WishRecord.new(wish_record_params)

    if @wish_record.save
      render 'wish_records', notice: 'Wish record was successfully created.'
    else
      render 'wish_records', status: :unprocessable_entity
    end
  end

  def remove_from_wishlist
    @wish_record.destroy
    render 'wish_records', notice: 'Wish record was successfully destroyed.'
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_recipes
    @recipes = Recipe.order(:updated_at).reverse
  end

  def recipe_params
    params.require(:recipe).permit(:name, :description, :ingredients)
  end

  def recipe_rating_params
    params.permit(:rating)
  end

  def set_cooking_record
    @cooking_record = CookingRecord.find(params[:id])
  end

  def set_cooking_records
    @cooking_records = CookingRecord.all
  end

  def cooking_record_params
    params.permit(:date)
  end

  def set_wish_record
    @wish_record = WishRecord.find(params[:id])
  end

  def set_wish_records
    @wish_records = WishRecord.all
  end

  def wish_record_params
    params.require(:wish_record).permit(:user_id, :recipe_id)
  end
end
