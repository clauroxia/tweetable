class AddIndexToLikes < ActiveRecord::Migration[7.0]
  def change
    add_index :likes, %i[user_id tweet_id], unique: true
  end
end
