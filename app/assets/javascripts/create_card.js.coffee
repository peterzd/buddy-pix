@validate_name = (e, name_value)->
  e.preventDefault()
  $.ajax(
    type: "post",
    url: "/cards/validate_name",
    data: { name: name_value },
    dataType: "json",
    success: (data)->
      if data.status
        $("#msg").empty()
        $(e.target.form).submit()
      else
        $("#msg").html "<div class='msg danger'><i class='fa fa-times'></i>this name is been taken. You can choose another one or joins this: </div>"
        $("#msg div").append "<a href=#{data.card_url}>#{name_value}</a>"
        $(".msg .fa-times").on 'click', ->
          $(this).parents('.msg').remove()
        e.preventDefault()
  )
