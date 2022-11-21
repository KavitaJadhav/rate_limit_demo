class RateLimitsController < ApplicationController
  def limits
    render json: APP_CONFIGS, status: :ok
  end
end
