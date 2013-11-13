class Api::CategoriesController < ApplicationController

  # !!!---this is actually a horrible security hole
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    render :json => ["Category destroyed!"]
  end

end