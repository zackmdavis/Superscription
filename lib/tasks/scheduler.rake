desc "This subscription-updating task is called by the Heroku scheduler add-on"
task :update_subscriptions => :environment do
  puts "Updating subscriptions..."
  Subscription.all.each do |subscription|
    if subscription.due_for_update?
      subscription.load_entries!
    end
  end
  puts "done updating subscriptions"
end