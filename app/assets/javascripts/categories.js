$(document).ready(function() {
  $('.subscription-draggable').draggable();
  $('.category-area').droppable({
    drop: function(event, ui) {
      $.ajax({
        url: "/api/user_subscriptions/" + $(ui.draggable).data("id") + "/change_category",
        type: "POST",
        data: {category_id: $(this).data("id")},
        success: function(response) {
          $.growl({ title: "Category Changed", message: response[0] });
        }
      });
    }
  });

  $('.delete-category').on("click", function(event) {
    event.preventDefault();
    var category_id = $(this).data("id");
    $.ajax({
      url: "/api/categories/" + category_id,
      type: "DELETE"
    })
    $('#category-area-' + category_id).fadeOut(250);
  });

});