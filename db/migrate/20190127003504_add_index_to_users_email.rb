class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
		# easier to perform index search for email rather than full table-scan
		add_index :users, :email, unique: true
  end
end
