Template.createLink.rendered = ->
  Session.setDefault 'nodes', [{name:'Search...'}]

Template.createLink.events
  'focusin #source, focusin #target': (e,t) ->
    $(e.currentTarget).next().toggleClass('hide')
  'focusout #source, focusout #target': (e,t) ->
    $(e.currentTarget).next().toggleClass('hide')
    Session.set 'nodes', [{name:'Search...'}]

  'keyup #source': (e,t) ->
    Meteor.call 'getNodes', t.find('#source').value, (err,res) ->
      Session.set 'nodes', res
  'keyup #target': (e,t) ->
    Meteor.call 'getNodes', t.find('#target').value, (err,res) ->
      Session.set 'nodes', res

  'mousedown li.source': (e,t) ->
    $('#source').val(this.name)
  'mousedown li.target': (e,t) ->
    $('#target').val(this.name)

  'click #create-link': (e,t) ->
    source = t.find('#source').value
    target = t.find('#target').value
    type = t.find('#link-type').value
    if type and source and target
      Meteor.call 'createLink', source, type, target, (err,res) ->
        alert "Successfully added link." if !err
        $('#source').val('')
        $('#target').val('')
        $('#link-type').val('')
    else alert "Please enter all values."


Template.createLink.helpers
  nodes: -> Session.get 'nodes'
  linkTypes: -> Session.get 'linkTypes'
