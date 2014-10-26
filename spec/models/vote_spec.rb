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

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :score }
  it { should validate_presence_of :votable }
  it { should validate_presence_of :user }
  it { should ensure_inclusion_of(:score).in_array([-1, 1]) }
# todo test fails
#   subject { FactoryGirl.create(:vote, votable: create(:question), user: create(:user), score: 1) }
#   it { should validate_uniqueness_of(:votable_id).scoped_to(:user_id, [:votable_type]) }

  it { should belong_to(:user) }
  it { should belong_to(:votable) }
end
