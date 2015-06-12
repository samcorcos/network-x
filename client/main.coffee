Template.main.rendered = ->
  Session.setDefault "graph", {nodes:[], links:[]}
  network = new Graph()
  Meteor.call 'getTags', (err,res) ->
    Session.set 'tags', res

  Tracker.autorun (c) ->
    graph = -> Session.get 'graph'
    network = new Graph()               ## TODO Right now this is kind of a hack... It just destroys the old svg and creates a new one every time.
    network.update(Session.get 'graph') ## TODO the data is updating, but it isn't displaying... What to do...

    # no longer hard-code tags
    # filter by tags

    # figure out the "expand-by-one" option

    # get more data onto nodes for click event to display with popover

Template.main.events
  'click .node': (e,t) ->
    console.log $(e.currentTarget).children('circle').attr('data-id') ## TODO there is probably a more efficient way to get the node-id on a click event...



Template.search.events
  'click button#submit-search': (e,t) ->
    query = t.find('input#search-query').value
    index = t.find('select').value
    Meteor.call "search", query, index, (err, res) ->
      Session.set 'graph', res
    $('input').val('')
    $('select').val('')

Template.search.helpers
  tags: -> Session.get 'tags'

Template.allData.events
  'click button': (e,t) ->
    Meteor.call "getGraph", (err, res) ->
      Session.set "graph", res
