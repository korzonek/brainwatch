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

require 'rails_helper'

RSpec.describe Attachment, :type => :model do
  it{should belong_to :attachable}
end
