class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!

  def main
    @subscriptions = current_user.subscriptions
    @entries = []
    @subscriptions.each do |subscription|
      @entries += subscription.entries.to_a
    end
    @entries.sort_by!{ |entry| entry.datetime }.reverse!
    render :main
  end

  def index
    @subscriptions = current_user.subscriptions
    render :index
  end

  def show
    @subscription = Subscription.find(params[:id])
    @entries = @subscription.entries
    @entries.sort_by!{ |entry| entry.datetime }.reverse!
    render :show
  end

end
