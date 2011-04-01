 $(document).ready(function() {
  var blah = [];

            
    $('#layer1').Draggable(
                    {
                            zIndex: 	20,
                            ghosting:	false,
                            opacity: 	0.7,
                            handle:	'#layer1_handle'
                    }
            );	

    $("#layer1").hide();
                            
    $('#preferences').click(function()
    {
            $("#layer1").show();
    });
    $('.btn').click(function() 
    {
        $("#layer1").hide();
    });

    $('#close').click(function()
    {
            $("#layer1").hide();
    });
          
  $("div[id^='comments_nav']").each(function() {
    $(this).hide();
    });
 
  $(".hide_comments").click(function()
    {
      var ID = $(this).attr("id");
      $("div#view_comments"+ID).hide();
      $("#comments_nav"+ID).hide();
      $(".comments[id=" + ID + "]").show();
    });

  $(".comments").click(function()
  {
  var ID = $(this).attr("id");
  if (blah[ID] == true) {
      $("div#view_comments"+ID).show();
      $(this).hide();
      $("#comments_nav"+ID).show();
  } else {
  $.ajax({
      type: "POST",
      url: "./view_comments",
      data: "msg_id="+ ID,
      cache: false,
      success: function(html) {
          blah[ID] = true;
          $("div#view_comments"+ID).prepend(html);
          $(".comments[id=" + ID + "]").hide();
          $("#comments_nav"+ID).show();
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

