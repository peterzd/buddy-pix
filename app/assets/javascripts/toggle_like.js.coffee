@toggle_like = ->
  container = $("#m-container")
  $(".like_icon").on "click", ->
    $(this).parent("div.like_box").fadeToggle(0, ->
      container.masonry()
    )
