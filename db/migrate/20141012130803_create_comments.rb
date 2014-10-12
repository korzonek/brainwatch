class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commentable, index: true
      t.string :commentable_type
      t.string :body
      t.integer :user_id, index: true
      t.timestamps
    end
  end
end
