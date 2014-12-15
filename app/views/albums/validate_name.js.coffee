if <%= !@show_msg %>
  $("#msg").html '<div class="msg danger"><i class="fa fa-times"></i>this name is been taken. Please choose another one</div>'

  $(".msg .fa-times").on 'click', ->
    $(this).parents('.msg').remove()
else
  $("#msg").empty()
