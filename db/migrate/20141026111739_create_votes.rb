class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: true
      t.references :user
      t.integer :score, limit: 1
      t.timestamps
    end
  end
end
