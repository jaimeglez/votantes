$(document).ready(function(){
  $('[data-tool="select2-tags"]').select2({
    theme: 'bootstrap',
    tags: true,
    width: 100
  });

  $("ul.select2-selection__rendered").sortable({
    containment: 'parent'
  });
});