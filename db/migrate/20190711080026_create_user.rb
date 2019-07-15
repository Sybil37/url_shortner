class CreateUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string   :user_name
      t.string   :email_address
      t.string   :password_hash
    end
  end
end
