class ApplicationController < ActionController::API
  class MoreActiveSession < StandardError; end


  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
      if @current_user && @current_user.invalid_token?(header)
      	raise JWT::ExpiredSignature
      end
      if @current_user.jwt_tokens.present? && @current_user.jwt_tokens.count > 1 && params[:action] != 'logout'
       raise MoreActiveSession
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::ExpiredSignature
    	render json: { errors: e.message }, status: :unauthorized
    rescue MoreActiveSession
    	render json: { errors: "There is already an active session using your account" }, status: :unauthorized    	
    end
  end	


end
