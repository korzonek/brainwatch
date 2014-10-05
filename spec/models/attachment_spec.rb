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

require 'rails_helper'

RSpec.describe Attachment, :type => :model do
  it{should belong_to :question}
end
