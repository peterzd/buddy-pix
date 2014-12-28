@get_tagged_ids = ->
  $("#invite_users_btn").on "click", ->
    $("#tagger_images ul").empty()
    items = $("input[name='tagged_user']:checked")
    total_checked = items.serialize()
    $("#photo_tagged_users").val(total_checked)

    for item in items.slice(0, 4)
      image_src = $(item).parents("li").find("figure img").attr("src")
      $("#tagger_images ul").append("<li><figure class='img_fill'><img src='#{image_src}'></figure></li>")
      $(".img_fill").imgLiquid { fill: true }
    $("#tagger_images ul").append("+ Others") if items.length > 4






