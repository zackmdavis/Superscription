class CategoriesController < ApplicationController

  before_filter :authenticate_user!

  def manage
    @categories = current_user.categories
    render :manage
  end

end
