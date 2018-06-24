class Following < ApplicationRecord
  before_save :ensure_different_users

  belongs_to :follower,
             class_name: 'User',
             foreign_key: :follower_id

  belongs_to :followee,
             class_name: 'User',
             foreign_key: :followee_id

  def trust
    cooked_recipes_by_follower = 0
    added_recipes_by_followee = followee.added_recipes
    return 0 if added_recipes_by_followee.empty?

    added_recipes_by_followee.each do |recipe|
      next unless CookingRecord.exists?(user_id: id, recipe_id: recipe[:id])

      cooked_recipes_by_follower += 1
    end

    (cooked_recipes_by_follower / added_recipes_by_followee.count.to_f).round(3)
  end

  def ensure_different_users
    return unless follower_id == followee_id

    raise StandardError, I18n.t('errors.no_follow_yourself')
  end
end
