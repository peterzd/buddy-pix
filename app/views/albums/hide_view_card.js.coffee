$("#<%= dom_id(@album) %>").remove()
container = document.querySelector('#m-container')
msnry =  new Masonry( container, {
    itemSelector: '.feed_box',
    columnWidth: 0
})

