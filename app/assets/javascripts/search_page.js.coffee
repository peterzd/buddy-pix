@ajax_search = ->
  $("#search-form").submit (e)->
    e.preventDefault()
    query_string = $("#search_query").val()
    query_type = $("#search_type").val() # cards or photos

    query_url = "/search_#{query_type}"
    $.ajax(
      type: "get",
      url: query_url,
      data: { type: query_type, query: query_string },
      dataType: "script",
      success: (data)->
        # console.log data
    )

    # change the load more link
    link = "/search_#{query_type}_batch?query=#{query_string}&page=1"
    container = $("#m-container")

    container.infinitescroll('destroy')
    container.data('infinitescroll', null)

    container.masonry()

    $("#page-nav a").attr "href", link
    load_more($("#m-container"))

