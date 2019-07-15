class CreateUrl < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string   :user_url
      t.integer  :user_id
      t.string   :gen_url
      t.timestamps
    end
  end
end
