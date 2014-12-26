@click_radio_elem = ->
  if $("#album_private_true").index() >  -1
    if $("#album_private_true").is(":checked")
      console.log "should click on private"
      $("#album_private_true").parent("div")[0]
    else
      $("#album_private_false").parent("div")[0]

