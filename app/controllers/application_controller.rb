class ApplicationController < ActionController::Base
  class Forbidden < ActionController::ActionControllerError; end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale, :set_mailer_host
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

  def side_column
    if user_signed_in?
      @communities = User.find_communities_with_user_id(current_user.id)
    end
  end

  # Override
  # See. https://github.com/plataformatec/devise/blob/3722aa62961720eafa5bb5ee6c99b76c26b6be3e/lib/devise/controllers/helpers.rb#L219-L230
  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  # See. https://railsguides.jp/i18n.html
  def set_locale
    I18n.locale = extract_locale_from_subdomain || I18n.default_locale
  end


  # リクエストのサブドメインからロケールを取り出す (https://en.kpter.net:3000のような形式)
  # この動作をローカルPCで行なうためには
  #   127.0.0.1 en.localhost:3000
  # /etc/hostsファイルに上のように記述する必要がある
  def extract_locale_from_subdomain
    parsed_locale = request.subdomains.first
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  # 本番環境だけ変更
  def default_url_options
    Rails.env.production? ? { protocol: :https }.merge(super) : super
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
    # リクエストを受けたサーバーのドメインとポートをメールで参照するURLにする
    def set_mailer_host
      ActionMailer::Base.default_url_options[:host] = request.host_with_port
    end
end
