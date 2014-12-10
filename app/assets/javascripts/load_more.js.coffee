@load_more = (container)->
  container.infinitescroll "bind"
  container.infinitescroll
    errorCallback: ->
      $(".loading_feed").remove()
      return

    navSelector: "#page-nav" # selector for the paged navigation
    nextSelector: "#page-nav a" # selector for the NEXT link (to page 2)
    itemSelector: ".feed_box" # selector for all items you'll retrieve
    loading:
      finishedMsg: "No more to load."
      msgText: "<em>Loading ...</em>"
      img: "http://i.imgur.com/6RMhx.gif"
      speed: "slow"

  , (newElements, opts) ->
    $(".img_fill").imgLiquid fill: true
    $(".img_set").imgLiquid fill: false
    $newElems = $(newElements)
    container.append($newElems).masonry "appended", $newElems, true
    return
  
