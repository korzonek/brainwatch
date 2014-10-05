# == Schema Information
#
# Table name: attachments
#
#  id          :integer          not null, primary key
#  question_id :integer
#  file        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_attachments_on_question_id  (question_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    question ""
  end
end
