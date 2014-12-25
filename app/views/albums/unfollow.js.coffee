$("#<%= dom_id(@album)%> a.btn").removeClass("dull").attr("href", "cards/<%= @album.id %>/follow").text("follow")
