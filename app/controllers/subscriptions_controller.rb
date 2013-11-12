class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!

  def main
    @user_subscriptions = current_user.user_subscriptions
    @categories = current_user.categories
    @category_entries = ActiveSupport::OrderedHash.new
    @categories.includes(:user_subscriptions).each do |category|
      @category_entries[category.name] = []
      category.user_subscriptions.each do |user_subscription|
        @category_entries[category.name] += user_subscription.unread_entries.to_a
      end
      @category_entries[category.name].sort_by! { |entry| entry.datetime }.reverse!
    end
    render :main
  end

  def index
    @user_subscriptions = UserSubscription.includes(:subscription).includes(:category).includes(:user).find_all_by_user_id(current_user.id)
    @user_subscriptions.sort_by! { |user_subscription| user_subscription.title }
    render :index
  end

  def show
    @subscription = Subscription.find(params[:id])
    @entries = @subscription.entries.includes(:subscription)
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

    # If another user has already subscribed to the same feed, use that and
    # just create a UserSubscription join model
    puts "using already stored feed!"
    existing_subscription = Subscription.find_by_url(params[:subscription][:url])
    if existing_subscription
      subscription_params[:user_subscriptions_attributes][0][:subscription_id] = existing_subscription.id
      user_subscription = UserSubscription.new(subscription_params[:user_subscriptions_attributes][0])
      if user_subscription.save
        redirect_to user_subscriptions_url(current_user)
        return
      else
        flash.now[:alert] = "Something went wrong! Couldn't save subscription."
        @subscription = Subscription.new
        @categories = current_user.categories
        render :new
        return
      end
    end

    # Otherwise, create a new Subscription (which accepts_nested_attributes_for
    # a UserSubscription)
    @subscription = Subscription.new(subscription_params)
    begin
      @subscription.load_everything!
    rescue NoMethodError, Errno::ENOENT
      @categories = current_user.categories
      flash.now[:alert] = "Could not interpret feed! Are you sure you have the correct URL?"
      render :new
      return
    end
    if @subscription.save
      redirect_to user_subscriptions_url(current_user)
    else
      flash.now[:alert] = @subscription.errors.full_messages.map { |message| message }.join("<p>")
      @categories = current_user.categories
      render :new
    end
  end

end
