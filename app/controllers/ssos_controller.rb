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
    if params[:sso][:return_to_params].present?
      base = "#{base}&#{params[:sso][:return_to_params]}"
    end
    base
  end

  def jwt_token
    payload = {
      data: data,
      iat: Time.now.to_i,
      nbf: Time.now.to_i - 3 * 1.minute,
      exp: Time.now.to_i + 5 * 1.minute,
      aud: "www.waggl.com"
    }
    hmac_secret = params[:sso][:secret_key]
    JWT.encode payload, hmac_secret, 'HS512'
  end

  def data
    information = { email: params[:sso][:email] }
    if params[:sso][:use_tags] == 'yes'
      if params[:sso][:tags].match(/^{.+}$/)
        information[:tags] = eval(params[:sso][:tags])
      else
        raise "Bad tags format"
      end
    end
    information
  end
end
