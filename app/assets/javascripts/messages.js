$(function() {
  $('#message_msg_type').on('change', function(e){
    console.log('changed');
    var msg_type = $(e.target).val();
    if(msg_type === 'text'){
      $('.message_content_text').removeClass('hidden');
      $('.message_content_video').addClass('hidden');
    }else{
      $('.message_content_video').removeClass('hidden');
      $('.message_content_text').addClass('hidden');
    }
  });
});
