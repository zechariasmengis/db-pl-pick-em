class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all
    render json: @users
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.create(user_params)
    # byebug
		render json: @user, status: :created
  end

  def login
    # byebug
    @user = User.find_by username: params[:user][:username]

		if @user && @user.authenticate(params[:user][:password])
			payload = { user_id: @user.id }
			secret = ENV['JWT_SECRET']
			@token = JWT.encode payload, secret
			render json: { token: @token }, status: :ok  
		else
			render json: {error: 'Invalid username or password'}, status: :unauthorized
		end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :password_digest, :email, :first_name, :last_name)
    end
end
