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
#  accepted    :boolean
#
# Indexes
#
#  index_answers_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should accept_nested_attributes_for :attachments }
end
