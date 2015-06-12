Template.main.rendered = ->
  Session.setDefault "graph", {nodes:[], links:[]}
  network = new Graph()

  Tracker.autorun (c) ->
    graph = -> Session.get 'graph'
    network = new Graph()               ## TODO Right now this is kind of a hack... It just destroys the old svg and creates a new one every time.
    network.update(Session.get 'graph') ## TODO the data is updating, but it isn't displaying... What to do...

Template.main.events
  'click .node': (e,t) ->
    console.log $(e.currentTarget).children('circle').attr('data-id') ## TODO there is probably a more efficient way to get the node-id on a click event...


Template.personSearch.events
  'click button': (e,t) ->
    query = t.find('input').value
    Meteor.call "searchPeople", query, (err, res) ->
      Session.set "graph", res
    $('input').val('')

Template.companySearch.events
  'click #cn-submit': (e,t) ->
    query = t.find('#company-name').value
    Meteor.call "searchCompany", query, undefined, (err, res) ->
      Session.set "graph", res
    $('input').val('')

  'click #ci-submit': (e,t) ->
    query = t.find('#company-industry').value
    Meteor.call "searchCompany", undefined, query, (err, res) ->
      Session.set "graph", res
    $('input').val('')

Template.allData.events
  'click button': (e,t) ->
    Meteor.call "getGraph", (err, res) ->
      Session.set "graph", res
