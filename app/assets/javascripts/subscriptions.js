$(document).ready(function(){

  $(".delete-user-subscription").click(function(event) {
    event.preventDefault();
    var user_subscription_id = $(this).data("id");
    var item_id = "#user-subscription-item-" + user_subscription_id;
    $(item_id).fadeOut(250);
    $.ajax({
      url: "/api/user_subscriptions/" + user_subscription_id,
      type: "DELETE"
    });
  });

});
