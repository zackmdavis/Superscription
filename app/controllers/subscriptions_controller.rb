class SubscriptionsController < ApplicationController

  def index
    @subscriptions = Subscription.find_all_by_user_id(params[:user_id])
    render :index
  end

end
