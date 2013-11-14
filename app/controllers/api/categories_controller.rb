class Api::CategoriesController < ApplicationController

  def create
    @category = Category.new(:name => params[:name])
    puts params
    @category.user = current_user
    if @category.save
      render :json => {:message => "#{@category.name} created!", :id => @category.id, :name => @category.name}
    else
      render :json => ["could not create category"], :status => 422
    end
  end

  # !!!---this is actually a horrible security hole
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    render :json => ["Category destroyed!"]
  end

end