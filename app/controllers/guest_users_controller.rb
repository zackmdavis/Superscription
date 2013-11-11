class GuestUsersController < ApplicationController

  def create
    guest_id = Time.now.to_i.to_s[2..-3]+rand(0..99).to_s
    guest_user_params = {:username => "Guest#{guest_id}",
                         :email => "guest#{guest_id}@example.org",
                         :password => "password#{guest_id}",
                         :password_confirmation => "password#{guest_id}",
                         :is_guest => true}
    guest_user = User.create!(guest_user_params)
    guest_category1 = Category.create(:name => "Current Events", :user_id => guest_user.id)
    guest_category2 = Category.create(:name => "Technology", :user_id => guest_user.id)
    # TODO --- pick specific guest subscriptions (not database ids 1 and 2!)
    UserSubscription.create(:category_id => guest_category1.id, :user_id => guest_user.id, :subscription_id => 1)
    UserSubscription.create(:category_id => guest_category2.id, :user_id => guest_user.id, :subscription_id => 2)
    sign_in_and_redirect guest_user
  end

end
