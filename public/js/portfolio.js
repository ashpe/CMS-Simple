 $(document).ready(function() {


     $( "#add-post" ).button().click(function() {
         $( "#post-form" ).dialog( "open" );
     });
  
    $( "#post-form" ).dialog({
                        autoOpen: false,
                        height: 300,
                        width: 350,
                        modal: true,
                        buttons: {
                                  Cancel: function() {
                                        $( this ).dialog( "close" );
                                 },
                        close: function() {
                                allFields.val( "" ).removeClass( "ui-state-error" );
                        }

                        }
     });


     $( ".ui-widget-content[foo='bar']" ).draggable();

     $('.edit').editable('./save', {
         indicator : 'Saving...',
         tooltip   : 'Click to edit...'
     });
     $('.edit_area').editable('./save', { 
         type      : 'textarea',
         cancel    : 'Cancel',
         submit    : 'OK',
         indicator : 'Saving...',
         tooltip   : 'Click to edit...'
     });
 });

