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
  $("#edit_user").validate({
    debug: true,
    rules: {
      "user[password]": {required: true, minlength: 6},
      "user[password_confirmation]": {required: true, equalTo: "#user_password"},
      "user[current_password]": {required: true, minlength: 6}
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
      "contact[mobile_number]": {required: true,  integer: true, minlength: 10, maxlength: 15},
      "contact[message]": {required: true}
    },
    submitHandler: function(form){
      form.submit();
    }
  });

  $.ajax({
          type:'GET',
          datatype:'json',
          url: '/galleries/get_image_count',
          success: function(response) {
            //$("#loader-div").hide();
            data = "Total Count "+response.data;
            //$('span.count').html(data).css('color', 'green');
            $('div#loader-div').html(data).css('color', 'green');
          },
    });
});