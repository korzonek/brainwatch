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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    commentable nil
    body 'My comment text'
  end
end
