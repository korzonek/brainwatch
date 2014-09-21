# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#

class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :body, presence: true
end
