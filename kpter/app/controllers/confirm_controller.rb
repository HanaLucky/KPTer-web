class ConfirmController < ApplicationController
  before_action :store_location

  def show
    puts "================="
    # sign_up画面以外からきた場合は、sign_up画面へ飛ばす
    # Users::RegistrationsController->after_inactive_sign_up_path_for参照
    unless session[:route_from_inactive_sign_up]
      redirect_to '/users/sign_up'
    end

    @email = session[:regist_email]

    session[:route_from_inactive_sign_up] = nil
    session[:regist_email] = nil
  end
end
