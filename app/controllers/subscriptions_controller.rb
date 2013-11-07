class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!

  def main
    @subscriptions = current_user.subscriptions
    @subscriptions.each do |subscription|
      if subscription.due_for_update?
        subscription.load_entries!
      end
    end
    @categories = current_user.categories
    @category_entries = ActiveSupport::OrderedHash.new
    @categories.each do |category|
      @category_entries[category.name] = []
      category.subscriptions.each do |subscription|
        @category_entries[category.name] += subscription.entries.to_a
      end
      @category_entries[category.name].sort_by! { |entry| entry.datetime }.reverse!
    end
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
    @subscription.set_default_info
    if @subscription.save
      @subscription.load_everything!
      redirect_to user_subscriptions_url(current_user)
    else
      flash[:alert] = @subscription.errors.full_messages.map { |message| message }.join("<p>")
      @categories = current_user.categories
      render :new
    end
  end

  # TODO: this should actually refer to a UserSubscription
  def edit
    @subscription = Subscription.find(params[:id])
    render :edit
  end

  # TODO: likewise
  def update
    @subscription = Subscription.find(params[:id])
    if @subscription.update_attributes(params[:subscription])
      flash[:notice] = "Updated #{@subscription.title}!"
      render :index
    else
      flash[:alert] = "Could not update #{@subscription.title}!"
      render :edit
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    flash[:notice] = "Unsubscribed from #{@subscription.title}!"
    @subscription.destroy
    redirect_to user_subscriptions_url(current_user)
  end

end
