container = $("#m-container")
container.masonry("destroy")

$("#m-container").html("<%=j(render partial: 'albums/photo', collection: @photos, as: 'photo', locals: { from: 'search' }) %>")

$(".img_fill").imgLiquid { fill: true }
$(".img_set").imgLiquid { fill: false }

container.masonry({
  itemSelector: '.feed_box'
})
