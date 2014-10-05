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

class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :question
end

