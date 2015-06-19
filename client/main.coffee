Template.main.rendered = ->
  Session.setDefault "graph", {nodes:[], links:[]}
  Session.setDefault 'creatingNode', false
  network = new Graph()
  Meteor.call 'getTags', (err,res) ->
    Session.set 'tags', res
  Meteor.call 'getLinkTypes', (err,res) ->
    Session.set 'linkTypes', res


  Tracker.autorun (c) ->
    graph = -> Session.get 'graph'
    network = new Graph()               ## TODO Right now this is kind of a hack... It just destroys the old svg and creates a new one every time.
    network.update(Session.get 'graph') ## TODO the data is updating, but it isn't displaying... What to do...


Template.main.events
  'click .node': (e,t) ->
    console.log $(e.currentTarget).children('circle').attr('data-id') ## TODO there is probably a more efficient way to get the node-id on a click event...


Template.allData.events
  'click button': (e,t) ->
    Meteor.call "getGraph", (err, res) ->
      Session.set "graph", res
