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

