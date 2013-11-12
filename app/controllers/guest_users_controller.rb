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
    category1_urls = ["http://www.sfgate.com/bayarea/feed/Bay-Area-News-429.php", "http://feeds.latimes.com/latimes/news/nationworld/nation"]
    category2_urls = ["http://feeds.wired.com/wired/index", "http://feeds.feedburner.com/TechCrunch/"]
    categories = {guest_category1 => category1_urls, guest_category2 => category2_urls}

    #debugger
    categories.each do |category, urls|
      urls.each do |url|
        subscription = Subscription.find_by_url(url)
        if subscription.nil?
          subscription = Subscription.create(:url => url)
          subscription.load_everything!
        end
        UserSubscription.create(:category_id => category.id, :user_id => guest_user.id, :subscription_id => subscription.id)
      end
    end

    sign_in_and_redirect guest_user
  end

end
