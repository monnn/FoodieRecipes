Rails.application.routes.draw do
  devise_for :users

  get '/users' => 'users#index', as: :users
  get '/users/:id' => 'users#show', as: :user
  get '/users/:id/edit' => 'users#edit_user', as: :edit_user
  get '/users/:id/ratings' => 'users#ratings', as: :ratings

  post '/users/:id' => 'users#update', as: :update_user
  post '/users/:id/follow' => 'users#follow_user', as: :follow_user

  get '/users/:id/recommendations' => 'users#content_based_recommendations'
  get '/users/:id/social_recommendations' => 'users#social_recommendations'
  get '/users/:id/user_based_recommendations' => 'users#user_based_recommendations'
  get '/users/:id/mixed_recommendations' => 'users#mixed_recommendations'

  get '/wish_records' => 'recipes#wishlist', as: :wish_records 
  delete '/wish_records/:id' => 'recipes#remove_from_wishlist' 

  get '/cooking_records' => 'recipes#cooking_records', as: :cooking_records
  delete '/cooking_records/:id' => 'recipes#uncook_recipes'

  get '/recipes' => 'recipes#recipes', as: :recipes
  get '/recipes/:id' => 'recipes#show', as: :recipe
  get '/recipes/:id/similar_recipes' => 'recipes#similar_recipes'

  post '/recipes/:id/rate' => 'recipes#rate_recipe', as: :rate_recipe
  post '/recipes/:id/cook' => 'recipes#cook_recipe', as: :new_cooking_record
  post '/recipes/:id/add_to_wishlist' => 'recipes#add_to_wishlist', as: :new_wish_record
end
