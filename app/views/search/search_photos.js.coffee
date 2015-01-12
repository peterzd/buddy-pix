container = $("#m-container")
container.masonry("destroy")

if <%= @photos.empty? %>
  container.html "<%=j(render partial: 'no_result')%>"
else
  container.html("<%=j(render partial: 'albums/photo', collection: @photos, as: 'photo', locals: { from: 'search' }) %>")

$(".img_fill").imgLiquid { fill: true }
$(".img_set").imgLiquid { fill: false }

container.masonry({
  itemSelector: '.feed_box'
})
