Template.createNode.events
  'change #node-label': (e,t) ->
    Session.set "creatingNode", true

  'click #create-node': (e,t) ->
    label = t.find('#node-label').value
    name = t.find('#new-node-name').value
    Meteor.call 'createNode', label, name, (err,res) ->
      console.log err if err
    $('#node-label').val('')
    $('#new-node-name').val('')

Template.createNode.helpers
  creatingNode: -> Session.get 'creatingNode'
