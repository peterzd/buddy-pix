#
# * jQuery File Upload Plugin JS Example 8.9.1
# * https://github.com/blueimp/jQuery-File-Upload
# *
# * Copyright 2010, Sebastian Tschan
# * https://blueimp.net
# *
# * Licensed under the MIT license:
# * http://www.opensource.org/licenses/MIT
# 

# global $, window 
file_upload = ->
  "use strict"
  
  # Initialize the jQuery File Upload widget:
  if window.location.pathname.match("/photos/new")
    $("#fileupload").fileupload
      
      # Uncomment the following to send cross-domain cookies:
      #xhrFields: {withCredentials: true},
      dataType: "script"
      url: "/images/photo_upload"

    
    # Enable iframe cross-domain access via redirect option:
    $("#fileupload").fileupload "option", "redirect", window.location.href.replace(/\/[^\/]*$/, "/cors/result.html?%s")
    if window.location.hostname is "blueimp.github.io"
      
      # Demo settings:
      $("#fileupload").fileupload "option",
        url: "//jquery-file-upload.appspot.com/"
        
        # Enable image resizing, except for Android and Opera,
        # which actually support image resizing, but fail to
        # send Blob objects via XHR requests:
        disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator.userAgent)
        maxFileSize: 5000000
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i

      
      # Upload server status check for browsers with CORS support:
      if $.support.cors
        $.ajax(
          url: "//jquery-file-upload.appspot.com/"
          type: "HEAD"
        ).fail ->
          $("<div class=\"alert alert-danger\"/>").text("Upload server currently unavailable - " + new Date()).appendTo "#fileupload"
          return

    else
      
      # Load existing files:
      $("#fileupload").addClass "fileupload-processing"
      
      # Uncomment the following to send cross-domain cookies:
      #xhrFields: {withCredentials: true},
      $.ajax(
        url: $("#fileupload").fileupload("option", "url")
        dataType: "json"
        context: $("#fileupload")[0]
      ).always(->
        $(this).removeClass "fileupload-processing"
        return
      ).done (result) ->
        $(this).fileupload("option", "done").call this, $.Event("done"),
          result: result

        return

  return


$(document).on "page:load ready", ->
  file_upload()
