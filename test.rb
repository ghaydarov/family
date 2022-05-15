module Admin
  class ApiController < Admin::ApplicationController
    include NitroAuth::Helpers

    skip_before_action :verify_authenticity_token
    before_action :api_login_required

    respond_to :json

    def api_login_required
      warden.authenticate!(:basic)
    end

    # If Authorization header present, api-token authentication is used
    # If no Authorization header present, uses warden for auth
    def check_api_token_or_login
      @key = request.headers["Authorization"]
      # token-based auth has a single param; multiple params are used by warden and unit test auth
      if @key.present? && @key.split.count == 1
        load_partner(api_key: @key)
      else
        warden.authenticate!(:basic)
      end
    end
  end
end