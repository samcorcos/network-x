searchRow = '<div class="search-row">content here</div>'

Template.createLink.events
  'focusin #source': (e,t) ->
    $('#source').append(searchRow)
  'focusout #source': (e,t) ->
    console.log e.which
