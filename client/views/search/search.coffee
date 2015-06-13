submitSearch = (e,t) ->
  query = t.find('input#search-query').value
  index = t.find('select').value
  tags = []
  ## Find all the tags that are checked on the DOM ##
  $('input.tag:checked').each -> tags.push $(this).attr('data-tag')

  ## Call search with all inputs ##
  Meteor.call "search", query, index, tags, (err, res) ->
    Session.set 'graph', res

  ## Clear inputs ##
  $('input').val('')
  $('select').val('')
  $('input.tag').removeAttr('checked')


Template.search.events
  ## TODO there has to be a way to combine these two... ##
  'click button#submit-search': (e,t) ->
    submitSearch(e,t)

  'focusin #search-query': (e,t) ->
    $(e.currentTarget).next().toggleClass('hide')
  'focusout #search-query': (e,t) ->
    $(e.currentTarget).next().toggleClass('hide')
    Session.set 'nodes', [{name:'Search...'}]

  'keyup #search-query': (e,t) ->
    if e.which is 13
      submitSearch(e,t)
    Meteor.call 'getNodes', t.find('#search-query').value, (err,res) ->
      Session.set 'nodes', res

  'mousedown li.search': (e,t) ->
    $('#search-query').val(this.name)


Template.search.helpers
  tags: -> Session.get 'tags'
  nodes: -> Session.get 'nodes'
