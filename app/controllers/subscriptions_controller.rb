class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!

  def main
    # user's main reading page --- TODO
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
