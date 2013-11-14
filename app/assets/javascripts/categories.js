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

  var new_category_form_html = '<form class="new-category-form"><br><p><strong>New Category Name</strong></p>' +
  '<p><input type="text" id="new-category-name"></p>' +
  '<p><input type="submit" id="new-category-submit" value="Create New Category &rarr;"></p></form>'
  $('#new-category-link').on("click", function(event) {
    event.preventDefault();
    var new_category_form = $('<div></div>');
    new_category_form.html(new_category_form_html);
    new_category_form.insertBefore('#request-new-category');
    $('.new-category-form').on("submit", function(event) {
      event.preventDefault();
      console.log(this);
      $.ajax({
        url: "/api/categories",
        type: "POST",
        data: { name: $('#new-category-name').val() },
        success: function(response) {
          console.log(response);
          var category_id = response.id;
          var category_name = response.name;
          var new_category_area = $('<div class="category-area" data-id="' +
            category_id + '" id="category-area-' + category_id + '"><p><strong>' +
            category_name + '</strong> &mdash; ' +
            '<a href="#" class="delete-category" data-id="' + category_id +
            '"><span class="glyphicon glyphicon-trash"></span></a></p></div>');
          new_category_area.insertBefore($('#request-new-category'));
          $('#category-area-' + category_id).droppable({
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
          // also need to add deletion handler to newly-created handler, but
          // this code has already gotten sufficiently unwieldly that I want to
          // refactor first
        }
      });
      $(this).fadeOut(250);
    })
  });



});