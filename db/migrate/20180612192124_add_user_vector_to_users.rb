class AddUserVectorToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :user_vector, :string
  end
end
