class CategoriesController < ApplicationController

  before_filter :authenticate_user!

  def new
    @category = Category.new
    render :new
  end

  def create
    @category = Category.create(params[:category])
    @category.user = current_user
    @entries = []
    if @category.save
       redirect_to user_subscriptions_url(current_user)
    else
      flash[:alert] = @category.errors.full_messages
      render :new
    end
  end

  def manage
    @categories = current_user.categories
    render :manage
  end

end
