class RateLimitsController < ApplicationController
  def limits
    render json: APP_CONFIGS, status: :ok
  end

  def user_access_history
    redis = Rack::Attack.cache.store.data
    keys = redis.keys("*rack::attack*")
    data = keys.map { |key| "#{key} : #{redis.get(key, raw: true)}" }
    render json: data, status: :ok
  end
end
