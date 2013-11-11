$(document).ready(function(){

  $(".mark-as-read").click(function(event) {
    event.preventDefault();
    var entry_id = $(this).data("id");
    var well_id = "#entry-well-" + entry_id;
    $(well_id).fadeTo(250, 0.3);
    // why isn't this working??
    $.ajax({
      url: "/api/readings",
      type: "POST",
      dataType: "json",
      data: {entry_id: entry_id}
    });
  });

});