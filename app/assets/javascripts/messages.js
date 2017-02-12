$(function() {
  $('#message_zones_ids, #message_sections_ids, #message_squares_ids').select2({
    theme: 'bootstrap',
    multiple: true
  });

  $('#message_msg_type').on('change', function(e){
    var msg_type = $(e.target).val();
    if(msg_type === 'text'){
      $('.message_content_text').removeClass('hidden');
      $('.message_content_video').addClass('hidden');
    }else{
      $('.message_content_video').removeClass('hidden');
      $('.message_content_text').addClass('hidden');
    }
  });

  var zonesGral = [];
  var sectionsGral = [];
  var squaresGral = [];

  $('#message_group_type').on('change', function(e){
    $('.form-group.receivers_container').addClass('hidden');
    var groupType = $(e.target).val();

    if(groupType == 'zones'){
      $('.form-group.message_zones_ids').removeClass('hidden');
      if (zonesGral.length){
        $('#message_zones_ids').empty();
        $.each(zonesGral, function(i, zone) {
          $('#message_zones_ids').append('<option value="' + zone.id + '">' + zone.name + '</option>');
        });
      }else{
        $.ajax({
          method: "GET",
          url: "/admin/zones",
          dataType: 'json'
        })
        .done(function(zones) {
          zonesGral = zones;
          $('#message_zones_ids').empty();
          $.each(zones, function(i, zone) {
            $('#message_zones_ids').append('<option value="' + zone.id + '">' + zone.name + '</option>');
          });
        });
      }
    }
    if(groupType == 'sections'){
      $('.form-group.message_sections_ids').removeClass('hidden');
      if (sectionsGral.length){
        $('#message_sections_ids').empty();
        $.each(sectionsGral, function(i, section) {
          $('#message_sections_ids').append('<option value="' + section.id + '">' + section.name + '</option>');
        });
      }else{
        $.ajax({
          method: "GET",
          url: "/admin/sections",
          dataType: 'json'
        })
        .done(function(sections) {
          sectionsGral = sections;
          $('#message_sections_ids').empty();
          $.each(sections, function(i, section) {
            $('#message_sections_ids').append('<option value="' + section.id + '">' + section.name + '</option>');
          });
        });
      }
    }
    if(groupType == 'squares'){
      $('.form-group.message_squares_ids').removeClass('hidden');
      if (squaresGral.length){
        $('#message_squares_ids').empty();
        $.each(squaresGral, function(i, square) {
          $('#message_squares_ids').append('<option value="' + square.id + '">' + square.name + '</option>');
        });
      }else{
        $.ajax({
          method: "GET",
          url: "/admin/squares",
          dataType: 'json'
        })
        .done(function(squares) {
          squaresGral = squares;
          $('#message_squares_ids').empty();
          $.each(squares, function(i, square) {
            $('#message_squares_ids').append('<option value="' + square.id + '">' + square.name + '</option>');
          });
        });
      }
    }

  });

});
