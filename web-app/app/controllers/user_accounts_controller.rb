class UserAccountsController < ApplicationController

  def index
    @users = UserAccount.publicly_listable.limit(2000)
  end

  def show
    @user = UserAccount.joins(:profile).find_by!('profiles.username = ? AND profiles.public = true', params[:id])
  end

end
