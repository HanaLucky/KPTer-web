class ApplicationController < ActionController::Base
  class Forbidden < ActionController::ActionControllerError; end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :store_location, :configure_permitted_parameters, if: :devise_controller?
  after_action :store_location

  rescue_from Forbidden, with: :render_403

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        request.path != root_path &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:next] || mypage_path
  end

  protected
    def configure_permitted_parameters
      # see. https://github.com/plataformatec/devise#strong-parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
      devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
    end

  private
    def render_403
      render file: Rails.root.join('public/403.html'), status: :forbidden, layout: false, content_type: 'text/html'
    end

end
