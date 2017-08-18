$(document).ready(function() {
  $("#new_user").validate({
    debug: true,
    rules: {
      "user[email]": {required: true, email: true },
      "user[password]": {required: true, minlength: 6},
      "user[password_confirmation]": {required: true, equalTo: "#user_password"}
    },
    submitHandler: function(form){
      form.submit();
    }
  });
  
  $("#new_contact").validate({
    debug: true,
    rules: {
      "contact[email]": {required: true, email: true},
      "contact[name]": {required: true},
      "contact[mobile_number]": {required: true, minlength: 10, maxlength: 15},
      "contact[message]": {required: true}
    },
    submitHandler: function(form){
      form.submit();
    }
  });
});