# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer
#  commentable_type :string(255)
#  body             :string(255)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_comments_on_commentable_id  (commentable_id)
#

require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should belong_to :commentable }
  it { should validate_presence_of :body }
end
