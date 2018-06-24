# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|

      ## For devise authentication
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.datetime :remember_created_at

      t.string :name
      t.string :role
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
