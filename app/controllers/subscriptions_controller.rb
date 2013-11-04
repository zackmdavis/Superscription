class SubscriptionsController < ApplicationController

  def index
    puts "current user is", current_user.username
    @subscriptions = Subscription.find_all_by_user_id(params[:user_id])
    render :index
  end

end
