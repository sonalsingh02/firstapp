class RemoveResetDigestFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :reset_digest, :string
  end
end
