class SsosController < ApplicationController
  def show
    @secret_key = ENV["WAGGL_SECRET_KEY"] || "Z4QEyFPqhAQXFuT7D_f2PQ"
    @waggl_server = ENV["WAGGL_HOST"] || "http://localhost:3000"
  end

  def create
    redirect_to redirect_url
  end

  private

  def redirect_url
    base = "#{params[:sso][:waggl_server] + params[:sso][:return_to_path]}?sso_jwt=#{jwt_token}"
    if params[:sso][:return_to_params]
      base = "#{base}&#{params[:sso][:return_to_params]}"
    end
    base
  end

  def jwt_token
    payload = {email: params[:sso][:email]}
    hmac_secret = params[:sso][:secret_key]
    JWT.encode payload, hmac_secret, 'HS512'
  end
end
