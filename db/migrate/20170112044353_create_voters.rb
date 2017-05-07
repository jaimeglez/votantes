class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters, id: :uuid do |t|
      t.string :full_name, limit: 150
      t.string :address
      t.string :electoral_number, limit: 18, unique: true
      t.string :latitude
      t.string :longitude
      t.string :phone_number
      t.string :social_network
      t.integer :role, index: true
      t.string :email
      t.boolean :active, default: true, index: true
      t.uuid :square_id, index: true
      t.string :audio

      t.string :provider, null: false, default: 'email'
      t.string :uid, default: ''
      t.string :encrypted_password, default: ''
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count, null: false, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.string :confirmation_token
      t.json :tokens
      t.string :email

      t.timestamps null: false
    end

    add_index :voters, :email,                unique: true
    add_index :voters, [:uid, :provider],     unique: true
    add_index :voters, :reset_password_token, unique: true
    add_index :voters, :confirmation_token,   unique: true
  end
end
