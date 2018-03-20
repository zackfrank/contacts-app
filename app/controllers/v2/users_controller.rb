class V2::UsersController < ApplicationController
  def index
    users = User.all.order(:id)
    render json: users.as_json
  end 

  def show
    id = params[:id]
    user = User.find_by(id: id)
    render json: user.as_json
  end

  def create
    user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
      )

    if user.save
      render json: {message: "User Successfully Created!"}, status: :created
    else
      render json: {errors: user.errors.full_messages}, status: 400
    end
  end
end
