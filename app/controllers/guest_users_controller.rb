class GuestUsersController < ApplicationController

  def create
    guest_id = User.count + 1
    guest_user_params = {:username => "Guest#{guest_id}",
                         :email => "guest#{guest_id}@example.org",
                         :password => "password#{guest_id}",
                         :password_confirmation => "password#{guest_id}",
                         :is_guest => true}
    guest_user = User.create!(guest_user_params)

    guest_category1 = Category.create(:name => "Current Events", :user_id => guest_user.id)
    guest_category2 = Category.create(:name => "Technology", :user_id => guest_user.id)
    category1_urls = ["http://www.sfgate.com/rss/feed/National-News-RSS-Feed-435.php", "http://feeds.contracostatimes.com/mngi/rss/CustomRssServlet/571/200819.xml"]
    category2_urls = ["http://feeds.feedburner.com/TechCrunch/", "http://feeds.bbci.co.uk/news/technology/rss.xml"]
    categories = {guest_category1 => category1_urls, guest_category2 => category2_urls}

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
