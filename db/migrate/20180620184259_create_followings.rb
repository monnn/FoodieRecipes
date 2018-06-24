class CreateFollowings < ActiveRecord::Migration[5.1]
  def change
    create_table :followings do |t|
      t.integer :follower_id
      t.integer :followee_id
    end

    add_foreign_key :followings, :users,
                    column: :follower_id,
                    name: :followings_users_follower_id_fk

    add_foreign_key :followings, :users,
                    column: :followee_id,
                    name: :followings_users_followee_id_fk
  end
end
