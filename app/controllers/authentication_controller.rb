class AuthenticationController < ApplicationController
  def authenticate
    @user = User.find_by_username(params['username'])
    if @user
      render json: @user.as_json, status: :ok
    else
      render json: @user.as_json, status: :not_found
    end
  end
end
