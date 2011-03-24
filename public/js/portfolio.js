 $(document).ready(function() {
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

