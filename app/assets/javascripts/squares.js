$(function() {
  $('#square_zone_id').on('change', function(e){
    var zoneId = $(e.target).val();
    $.ajax({
      method: "GET",
      url: "/admin/sections",
      dataType: 'json',
      data: { zone_id: zoneId }
    })
    .done(function( sections ) {
      $('#square_section_id').empty();
      $.each(sections, function(i, section) {
        $('#square_section_id').append('<option value="' + section.id + '">' + section.name + '</option>');
      });
    });
  });
});
