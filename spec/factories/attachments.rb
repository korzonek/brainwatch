# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  attachable_id   :integer
#  file            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  attachable_type :string(255)
#
# Indexes
#
#  index_attachments_on_attachable_id  (attachable_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :attachment do
    file { fixture_file_upload("#{Rails.root}/spec/fixtures/files/attachment.txt") }
  end
end
