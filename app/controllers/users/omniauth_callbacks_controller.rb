class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      @profile = SocialProfile.where(provider: @omniauth.provider, uid: @omniauth.uid).first
      unless @profile
        @profile = SocialProfile.new(
          provider: @omniauth.provider,
          uid: @omniauth.uid,
          name: @omniauth.info.name,
          email: @omniauth.info.email,
          image_url: @omniauth.info.image,
          auth_info: @omniauth.to_json
        )
        @profile.user = current_user || User.create!(
          nickname: @omniauth.info.name,
          email:    @omniauth.info.email,
          password: Devise.friendly_token[0, 20],
          only_oauth_registration: true
        )
        @profile.save!
      end
      if current_user
        raise "user is not identical" if current_user != @profile.user
      else
        @profile.user.skip_confirmation!
        sign_in(:user, @profile.user)
      end
      redirect_to request.env['omniauth.params']['return_url'] || mypage_path
    end
  end
end
