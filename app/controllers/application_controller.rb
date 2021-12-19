class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token

    before_action :authenticate

	def authenticate
		auth_header = request.headers[:Authorization]

		if !auth_header
				render json: { error: 'Auth bearer token header must be present' }, status: :forbidden
		else
				token = auth_header.split(' ')[1]
				secret = ENV['JWT_SECRET']
				begin
						decoded_token = JWT.decode token, secret
						user_id = decoded_token[0]["user_id"]
						@user = User.find_by(id: user_id)
				rescue
						render json: { error: 'Bad token' }, status: :forbidden
				end
		end
	end
end
