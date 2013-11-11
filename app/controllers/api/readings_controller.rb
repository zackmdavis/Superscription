class Api::ReadingsController < ApplicationController

  def create
    UserEntryReading.create(:user_id => current_user.id, :entry_id => params[:id])
    puts "PARAMS ARE"
    puts params
    render :json => ["Reading created"]
  end

end
