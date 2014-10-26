# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#

class Question < ActiveRecord::Base
  validates :title, :body, presence: true
  has_many :answers
  belongs_to :user
  has_one :accepted_answer, class_name: 'Answer'
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable
  accepts_nested_attributes_for :attachments, allow_destroy: true

  has_many :question_tags
  has_many :tags, through: :question_tags

  # has_and_belongs_to_many :tags

  def accepted_answer
    answers.find_by(answers: {accepted: true})
  end

  def accept_answer(accepted_answer)
    self.accepted_answer.update(accepted: false) if self.accepted_answer
    accepted_answer.update(accepted: true)
  end

  def author?(other_user)
    user == other_user
  end

  def tags_str
    tags.pluck(:name).join(' ')
  end

  def tags_str=(string)
    self.tags = Tag.from_string(string).uniq
  end
end
