class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @omniauth = request.env['omniauth.auth']

    if @omniauth.present?
      @profile = SocialProfile.where(provider: @omniauth.provider, uid: @omniauth.uid).first
      # 新規でソーシャル連携してきたユーザーの場合、ソーシャル連携情報とユーザーを登録する
      unless @profile
        @profile = SocialProfile.new(
          provider: @omniauth.provider,
          uid: @omniauth.uid,
          name: @omniauth.info.name,
          email: @omniauth.info.email,
          image_url: @omniauth.info.image,
          auth_info: @omniauth.to_json
        )
        # 未ログインの場合は、完全新規とみなしてユーザー情報を登録する
        # Sign upからのソーシャル連携で処理される
        if current_user.nil?
          @profile.user = User.new(
            nickname: @omniauth.info.name,
            email:    @omniauth.info.email,
            password: Devise.friendly_token[0, 20],
            only_oauth_registration: true
          )
          @profile.user.skip_confirmation_notification!
          @profile.user.save!
        else
          @profile.user = current_user
        end
      end
      # ログイン中の場合（ユーザー編集画面からソーシャルコネクトする時に処理される）
      if current_user
        # your social account have already registered another account in kpter
        if current_user != @profile.user
          flash[:alert] = I18n.t('social.failure.already_associated', provider: "Google", email: @omniauth.info.email)
          redirect_to edit_user_registration_path and return
        end
        # ソーシャル情報をユーザーに紐づけて登録する
        @profile.save!
      else
        # 未ログインの場合（Sign up画面からソーシャル連携で登録する時に処理される）
        @profile.save!
        @profile.user.skip_confirmation!
        sign_in(:user, @profile.user)
      end
      redirect_to request.env['omniauth.params']['return_url'] || mypage_path
    else
      # ないはずはないが、認証情報がない場合は500 Internal Server Errorにする
      logger.error "Not found omniauth.auth information."
      render file: "#{Rails.root}/public/500.html", layout: false, status: :internal_server_error
    end
  end
end
