$("#msg").html '<div class="msg success"><i class="fa fa-times"></i>You accepted an invitation!</div>'

$("#<%= dom_id(@invitation) %>").hide "slow"
$(".msg .fa-times").on 'click', ->
  $(this).parents('.msg').remove()
