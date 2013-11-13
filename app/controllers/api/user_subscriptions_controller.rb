class Api::UserSubscriptionsController < ApplicationController

  def change_category
    @user_subscription = UserSubscription.find(params[:id])
    @user_subscription.category_id = params[:category_id]
    if @user_subscription.save
      puts "success"
      render :json => ["Category changed!"]
    else
      render :json => ["could not change category"]
    end
  end

  # !!!---this is actually a horrible security hole
  def destroy
    @user_subscription = UserSubscription.find(params[:id])
    @user_subscription.destroy
    render :json => ["Unsubscribed!"]
  end

end
