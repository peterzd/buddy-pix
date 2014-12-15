@validate_name = ->
  $("#album_name").on "blur", ->
    value = $(this).val()
    $.ajax(
      type: "post",
      url: "/cards/validate_name",
      data: { name: value },
      dataType: "json",
      success: (data)->
        if !data.status
          $("#msg").html '<div class="msg danger"><i class="fa fa-times"></i>this name is been taken. Please choose another one</div>'
          $(".msg .fa-times").on 'click', ->
            $(this).parents('.msg').remove()
        else
          $("#msg").empty()
    )

