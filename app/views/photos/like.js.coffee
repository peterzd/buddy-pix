$("#<%= dom_id(@photo) %> .like_btn strong").text("<%= @photo.likers.count %>")
$("#<%= dom_id(@photo) %> .like_btn").addClass("active").data("liked", true)
