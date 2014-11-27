$("#msg").html '<div class="msg info"><i class="fa fa-times"></i>You declined an invitation</div>'

$("#<%= dom_id(@invitation) %>").addClass "decline"

$(".msg .fa-times").on 'click', ->
  $(this).parents('.msg').remove()
