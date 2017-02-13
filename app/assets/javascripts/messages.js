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
    groupType = $(e.target).val();
    fillData(groupType);
  });

  var fillData = function(groupType){
    switch(groupType) {
      case 'zones':
        $('.form-group.message_zones_ids').removeClass('hidden');
        if (zonesGral.length){
          populateSelect('message_zones_ids', zonesGral);
        }else{
          getEntityData('message_zones_ids');
        }
        break;
      case 'sections':
        $('.form-group.message_sections_ids').removeClass('hidden');
        if (sectionsGral.length){
          populateSelect('message_sections_ids', sectionsGral);
        }else{
          getEntityData('message_sections_ids');
        }
        break;
      case 'squares':
        $('.form-group.message_squares_ids').removeClass('hidden');
        if (squaresGral.length){
          populateSelect('message_squares_ids', squaresGral);
        }else{
          getEntityData('message_squares_ids');
        }
        break;
    }
  }

  var populateSelect = function(selectId, collection){
    $('#' + selectId).empty();
    $.each(collection, function(i, entity) {
      $('#' + selectId).append('<option value="' + entity.id + '">' + entity.name + '</option>');
    });
  }

  var getEntityData = function(selectId){
    $.ajax({
      method: 'GET',
      url: API_URL + groupType,
      dataType: 'json'
    })
    .done(function(collection) {
      switch(groupType) {
        case 'zones':
          zonesGral = collection;
            break;
        case 'sections':
          sectionsGral = collection;
            break;
        case 'squares':
          squaresGral = collection;
            break;
      }
      populateSelect(selectId, collection);
    });
  }

  var groupType = $('#message_group_type').val();
  fillData(groupType);

});
