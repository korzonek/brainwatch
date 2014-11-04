# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_authorizations_on_provider_and_uid  (provider,uid)
#  index_authorizations_on_user_id           (user_id)
#

class Authorization < ActiveRecord::Base
  belongs_to :user
end
