class SupportTicketController < ApplicationController
  def create
    @user = User.find_by_username(params['username'])
    @ticket = SupportTicket.new(user_id: @user.id, note: params['note'])
    render json: @ticket.as_json, status: :created
  end
end
