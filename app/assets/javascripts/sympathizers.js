$(document).ready(function(){
  window.Parsley.addValidator('validateSympathizer', {
    messages: {es: 'Al menos uno de estos valores debe ser seleccionado'},
    requirementType: 'integer',
    validate: function(_value, requirement, instance) {
      var valid;
      for(var i = 0; i < instance.parent.fields.length; i++) {
        value = instance.parent.fields[i].$element.val();
        if (value && value != '')
          return true;
      }
      return false;
    }
  });
});