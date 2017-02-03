class AddDeviseTokenAuthFields < ActiveRecord::Migration
   def change
     add_column :voters, :provider, :string, null: false, default: 'email'
     add_column :voters, :uid, :string, null: false, default: ''
     add_column :voters, :encrypted_password, :string, null: false, default: ''
     add_column :voters, :reset_password_token, :string
     add_column :voters, :reset_password_sent_at, :datetime
     add_column :voters, :remember_created_at, :datetime
     add_column :voters, :sign_in_count, :integer, null: false, default: 0
     add_column :voters, :current_sign_in_at, :datetime
     add_column :voters, :last_sign_in_at, :datetime
     add_column :voters, :current_sign_in_ip, :string
     add_column :voters, :last_sign_in_ip, :string
     add_column :voters, :confirmation_token, :string
     add_column :voters, :tokens, :json
     add_column :voters, :email, :string

     add_index :voters, :email,                unique: true
     add_index :voters, [:uid, :provider],     unique: true
     add_index :voters, :reset_password_token, unique: true
     add_index :voters, :confirmation_token,   unique: true
  end
end
