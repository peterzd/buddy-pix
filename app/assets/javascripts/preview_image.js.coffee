@preview_image = (input, target_object) ->
  if input.files and input.files[0]
    reader = new FileReader()
    reader.onload = (e) ->
      target_object.attr "src", e.target.result
      target_object.css("width", "100%").css("height", "100%")
      return

    reader.readAsDataURL input.files[0]

