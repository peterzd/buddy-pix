container = $("#m-container")
container.masonry("destroy")

if <%= @cards.empty? %>
  container.html("<%=j(render partial: 'no_result')%>")
else
  container.html("<%=j(render partial: 'albums/card_detail', collection: @cards, as: 'card') %>")

$(".img_fill").imgLiquid { fill: true }
$(".img_set").imgLiquid { fill: false }

container.masonry({
  itemSelector: '.feed_box'
})

