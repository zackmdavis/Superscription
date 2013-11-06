class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    @subscriptions = @category.subscriptions
    @entries = []
    @subscriptions.each do |subscription|
      @entries += subscription.entries.to_a
    end
    @entries.sort_by!{ |entry| entry.datetime }.reverse!
    render :show
  end

end
