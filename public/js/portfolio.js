 $(document).ready(function() {
  var blah = [];

  $("#comments_nav").hide();
 
  $(".hide_comments").click(function()
    {
      var ID = $(this).attr("id");
      $("div#view_comments"+ID).hide();
      $("#comments_nav").hide();
      $(".comments").show();
    });

  $(".comments").click(function()
  {
  var ID = $(this).attr("id");
  
  if (blah[ID] == true) {
      $("div#view_comments"+ID).show();
      $(".comments").hide();
      $("#comments_nav").show();
  } else {
  $.ajax({
      type: "POST",
      url: "./view_comments",
      data: "msg_id="+ ID,
      cache: false,
      success: function(html) {
         // alert(html);
          blah[ID] = true;
          $("div#view_comments"+ID).prepend(html);
          $(".comments").hide();
          $("#comments_nav").show();
      }
      });
  return false;
  }
  });


  
   $( ".ui-widget-content[foo='bar']" ).draggable();

   $('.edit').editable('./save', {
       type      : 'text',
       event     : 'dblclick',
       cancel    : 'cancel',
       submit    : 'submit',
       indicator : 'saving...',
       tooltip   : 'click to edit...',
       style     : 'inherit'
   });
   $('.edit_area').editable('./save', { 
       type      : 'textarea',
       cancel    : 'cancel',
       event     : 'dblclick',
       submit    : 'submit',
       indicator : 'saving...',
       tooltip   : 'click to edit...',
       style     : 'inherit'
   });

});

