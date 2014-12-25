container = document.querySelector("#m-container")
masy = Masonry.data container
masy.remove($("#album_<%= @id %>"))
masy.layout()

