class UserAccounts::DashboardController < ApplicationController

  layout 'application'

  prepend_before_action :authenticate_user_account!

  def index;end

end
