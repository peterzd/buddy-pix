$("#<%= dom_id(@album)%> a.btn").addClass("dull").attr("href", "/cards/<%= @album.id %>/unfollow").text("unfollow")


