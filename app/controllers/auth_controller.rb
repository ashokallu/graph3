class AuthController < ApplicationController
  skip_before_filter :set_user

  # This method will be called by the OmniAuth middleware once the OAuth flow is complete.
  # def callback
  #   # Access the authentication hash for omniauth
  #   data = request.env['omniauth.auth']

  #   # Temporary for testing!
  #   render json: data.to_json
  # end

  def callback
    # Access the authentication hash for omniauth
    data = request.env['omniauth.auth']

    # Save the data in the session
    save_in_session data

    redirect_to root_url
  end

  def signout
    reset_session
    redirect_to root_url
  end
end
