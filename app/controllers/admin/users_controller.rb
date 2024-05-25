class Admin::UsersController < ApplicationController
  before_action :authorize_user!

  wrap_parameters :user, include: [:email, :password, :payout_rate]

  def create_client
    @client = User.new(client_params)
    if @client.save
      render json: @client, status: :created
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:user).permit(:email, :password, :payout_rate)
  end
end
