$(document).ready(function(){

  $('#subscription-tabs a:first').tab('show');

  var active_tab = window.location.hash;
  var prefix = "_"
  $('#subscription-tabs a[href="' + active_tab.replace(prefix, '') + '"]').tab('show');

  $('#subscription-tabs a').on('click', function(event) {
    window.location.hash = event.target.hash.replace("#", "#" + prefix);
  });

  $('.mark-as-read').click(function(event) {
    event.preventDefault();
    var entry_id = $(this).data("id");
    var well_id = "#entry-well-" + entry_id;
    $(well_id).fadeTo(250, 0.3);
    $.ajax({
      url: "/api/readings",
      type: "POST",
      dataType: "json",
      data: {entry_id: entry_id}
    });
  });

});