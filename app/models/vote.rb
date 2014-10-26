# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  votable_id   :integer
#  votable_type :string(255)
#  user_id      :integer
#  score        :integer
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_votes_on_votable_id_and_votable_type  (votable_id,votable_type)
#

class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :votable, :user_id, :score, :user, presence: true
  validates :score, inclusion: -1..1
  validates_uniqueness_of :votable_id, scope: [:user_id, :votable_type]
end
