@ajax_search = ->
  $("#search-form").submit (e)->
    e.preventDefault()
    query_string = $("#search_query").val()
    query_type = $("#search_type").val()

    query_url = "/search_#{query_type}"
    $.ajax(
      type: "get",
      url: query_url,
      data: { type: query_type, query: query_string },
      dataType: "script",
      success: (data)->
        console.log data
    )

