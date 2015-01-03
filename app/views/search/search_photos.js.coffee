$("#m-container").html("<%=j(render partial: 'albums/photo', collection: @photos, as: 'photo', locals: { from: 'search' }) %>")

$(".img_fill").imgLiquid { fill: true }
$(".img_set").imgLiquid { fill: false }

container = document.querySelector('#m-container')
msnry = new Masonry(container, {
    itemSelector: '.feed_box',
    columnWidth: 0
})
