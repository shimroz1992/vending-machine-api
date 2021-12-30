class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /login
  def login
    @user = User.find_by_username(params[:username])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      @user.jwt_tokens.create!(token: token)
      time = Time.now - 10
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     username: @user.username }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def logout
    if @current_user.jwt_tokens.present? && @current_user.jwt_tokens.count > 1
    	@current_user.jwt_tokens.destroy_all
    	render json: {message: 'All session were destroyed successfully, please generate new token.'}, status: :ok
    else
    	render json: {error: 'No session to destroy'}, status: :unauthorized
    end
   
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end