class Api::V1::ProfilesController < Api::V1::ApiController
  doorkeeper_for :all
  respond_to :json

  def me
    respond_with current_resource_owner
  end

end
