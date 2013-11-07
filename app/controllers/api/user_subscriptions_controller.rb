class Api::UserSubscriptionsController < ApplicationController

  def destroy
    @user_subscription = UserSubscription.find(params[:id])
    @user_subscription.destroy
    render :json => ["Unsubscribed!"]
  end

end
