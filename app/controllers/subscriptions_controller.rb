class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!

  def main
    # user's main reading page --- TODO
  end

  def index
    @subscriptions = Subscription.find_all_by_user_id(params[:user_id])
    render :index
  end

  def show
    @subscription = Subscription.includes(:entries).find(params[:id])
    @entries = @subscription.entries
    @entries.sort_by!{ |entry| entry.datetime }
    render :show
  end

end
