# == Schema Information
#
# Table name: question_tags
#
#  id          :integer          not null, primary key
#  question_id :integer
#  tag_id      :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_question_tags_on_question_id  (question_id)
#  index_question_tags_on_tag_id       (tag_id)
#

class QuestionTag < ActiveRecord::Base
  belongs_to :question
  belongs_to :tag
end
