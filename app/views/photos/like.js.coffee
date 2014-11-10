$("#<%= dom_id(@photo) %> .like_btn strong").text("<%= @photo.likers.count %>")
