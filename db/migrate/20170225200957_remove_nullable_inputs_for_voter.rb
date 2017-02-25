class RemoveNullableInputsForVoter < ActiveRecord::Migration
  def change
    change_column_null :voters, :uid, true
    change_column_null :voters, :encrypted_password, true
  end
end
