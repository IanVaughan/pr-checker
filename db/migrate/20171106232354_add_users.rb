class AddUsers < ActiveRecord::Migration[5.0]
  def self.up
    create_table :users, force: true do |t|
      t.string :name, null: false
      t.string :email
    end
  end

  def self.down
  end
end
