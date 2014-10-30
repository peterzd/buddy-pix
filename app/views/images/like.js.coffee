$("#<%= dom_id(@image) %> .like_btn strong").text("<%= @image.likers.count %>")
