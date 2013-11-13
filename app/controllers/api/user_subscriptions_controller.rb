class Api::UserSubscriptionsController < ApplicationController

  def change_category
    @user_subscription = UserSubscription.find(params[:id])
    @user_subscription.category_id = params[:category_id]
    subscription_title = @user_subscription.title
    new_category_name = Category.find(params[:category_id]).name
    if @user_subscription.save
      render :json => ["Moved #{subscription_title} to #{new_category_name}"]
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
