$ ->
  $("#place_address").autocomplete
    source: (request, response) ->
      $.ajax
        url: "//kartor.malmo.se/api/v1/addresses/"
        dataType: "jsonp"
        data:
          q: request.term
          items: 10
        success: (data) ->
          response $.map(data.addresses, (item) ->
            {
              label: "#{item.name}"
              value: item.name
              east: item.east
              north: item.north
            }
          )
          return
      return
    minLength: 2
    select: (event, ui) ->
      $('#place_east').val(ui.item.east)
      $('#place_north').val(ui.item.north)
      return
