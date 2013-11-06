class CategoriesController < ApplicationController

  def new
    @category = Category.new
    render :new
  end

  def create
    @category = Category.create(params[:category])
    @entries = []
    if @category.save
      render :show
    else
      flash[:alert] = @category.errors.full_messages
      render :new
    end
  end

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
