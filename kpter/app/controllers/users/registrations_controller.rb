class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # see. https://github.com/HanaLucky/KPTer-web/issues/183
  # DELETE /resource
  # def destroy
  #  super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # avatar image upload
  def upload
    if current_user.update_attributes(avatar: params[:qqfile])
      flash.keep[:notice] = t 'devise.registrations.update_avatar_image'
    else
      # XXX いまひとつ
      flash.keep[:alert] = current_user.errors.full_messages
    end
    # tokenリフレッシュするのに成功してもエラーでもレンダリングしなおすため、success固定で返す
    render json: {success: true}
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after edit user.
  # see. https://github.com/plataformatec/devise/wiki/How-To:-Customize-the-redirect-after-a-user-edits-their-profile
  def after_update_path_for(resource)
    edit_user_registration_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    # 仮登録画面からきたかどうかのフラグ。confirm画面で、フラグ判定し除去する。
    session[:route_from_inactive_sign_up] = 1
    session[:regist_email] = resource.email
    confirm_path
  end
end
