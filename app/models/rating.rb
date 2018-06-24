class Rating < ApplicationRecord
  before_save :ensure_unique
  after_create :update_user_vector

  belongs_to :user
  belongs_to :recipe

  def update_user_vector
    user.update_user_vector(self)
  end

  def ensure_unique
    return unless Rating.exists?(user_id: user_id, recipe_id: recipe_id)

    raise StandardError, I18n.t('errors.rate_only_once')
  end
end
