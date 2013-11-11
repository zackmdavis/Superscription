desc "This subscription-updating task is called by the Heroku scheduler add-on"
task :update_subscriptions => :environment do
  puts "Updating subscriptions..."
  Subscription.all.each do |subscription|
    if subscription.due_for_update?
      begin
        subscription.load_entries!
      rescue Exception => e
        puts "Exception caught!---i.e., something went wrong, namely"
        puts e.message
      end
    end
  end
  puts "done updating subscriptions"
end