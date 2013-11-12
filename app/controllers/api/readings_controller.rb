class Api::ReadingsController < ApplicationController

  def create
    UserEntryReading.create(:user_id => current_user.id, :entry_id => params[:entry_id])
    render :json => ["Reading created"]
  end

end
