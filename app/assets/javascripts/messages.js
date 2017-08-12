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

  // var zonesGral = [];
  // var sectionsGral = [];
  // var squaresGral = [];

  $('#message_group_type').on('change', function(e){
    var groupType = $(e.target).val();
    displayGroupSelect(groupType);
  });

  function displayGroupSelect(type) {
    var groupId = ".message_"+ type +"_ids";
    $(".receivers_container").addClass('hidden');
    $(groupId).removeClass('hidden');
  }
});
