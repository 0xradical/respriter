class ProfilesController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user_account!, except: [:index, :show]
  after_action :clear_notice

  def index
    @profiles = Profile.publicly_listable.limit(200) + OrphanedProfile.vacant.limit(100)
  end

  def show
    @user_account = Profile.find_by(username: params[:id]).user_account
  end

  def new
    @user_account = current_user_account
    @profile = @user_account.profile || @user_account.build_profile

    if @profile.username.present?
      redirect_to root_path
    else
      flash.delete(:alert)
      flash[:notice] = t('.notice')
    end
  end

  def create
    @user_account = current_user_account
    @profile = @user_account.profile || @user_account.build_profile

    profile_saved = false

    begin
      profile_saved = @profile.update(profile_params)

      @user_account.oauth_accounts.each do |oauth_account|
        oauth = oauth_account.raw_data || {}
        @profile.oauth_avatar_url ||=
          (oauth.dig('info', 'image') || oauth.dig('info', 'picture_url'))
        @profile.name ||= oauth.dig('info', 'name')
      end

      @profile.save
    rescue ActiveRecord::StatementInvalid => e
      pg_processor = PG::ResultProcessor.new(e.cause.result)
      @profile.errors.add(
        :base,
        I18n.t("db.#{pg_processor.error}"),
        field: :username
      )
      profile_saved = false
    end

    if profile_saved
      set_login_redirect_location
      redirect_to session[:login_redirect_location] and return
    else
      render :new
    end
  end

  protected

  def clear_notice
    flash.delete(:notice)
  end

  def profile_params
    params.require(:profile).permit(:username)
  end

  def set_login_redirect_location
    if session[:login_redirect_location].presence.nil?
      redirect_url = ENV.fetch('USER_DASHBOARD_URL')
      redirect_path = params[:user_dashboard_redir].presence || '/'

      session[:login_redirect_location] = "#{redirect_url}#{redirect_path}"
    end
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user_account, request.fullpath)
  end
end
