# frozen_string_literal: true

class UnsubscriptionsController < ApplicationController
  layout 'barebones'
  protect_from_forgery with: :null_session

  def show
    @id = params[:id]
    subscription = Subscription.find_by(id: params[:id])
    subscription.unsubscribe_from_everything!
    @email = subscription.profile&.user_account&.email
  end

  def update
    subscription = Subscription.find_by(id: params[:id])

    begin
      subscription.save_unsubscribe_reasons!({ reason: params[:reason], details: params[:details] })
    rescue StandardError => e
      flash[:alert] = e.message
      redirect_to request.referrer
      return
    end

    flash[:notice] = I18n.t('unsubscriptions.show.alerts.success')
    redirect_to root_path
  end
end
