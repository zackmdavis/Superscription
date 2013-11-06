class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!

  def main
    @subscriptions = current_user.subscriptions
    @entries = []
    @subscriptions.each do |subscription|
      @entries += subscription.entries.to_a
    end
    @entries.sort_by! { |entry| entry.datetime }.reverse!
    render :main
  end

  def index
    @user_subscriptions = UserSubscription.find_all_by_user_id(current_user.id)
    @user_subscriptions.sort_by! { |user_subscription| user_subscription.title }
    render :index
  end

  def show
    @subscription = Subscription.find(params[:id])
    @entries = @subscription.entries
    @entries.sort_by!{ |entry| entry.datetime }.reverse!
    render :show
  end

  def new
    @subscription = Subscription.new
    if current_user.categories.empty?
      current_user.categories.create(:name => "Uncategorized")
    end
    @categories = current_user.categories
    render :new
  end

  def create
    subscription_params = params[:subscription]
    subscription_params[:user_subscriptions_attributes][0][:user_id] = current_user.id
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      @subscription.load_everything!
      redirect_to user_subscriptions_url(current_user)
    else
      flash[:alert] = @subscription.errors.full_messages
      render :new
    end
  end

  def destroy
  end

end
