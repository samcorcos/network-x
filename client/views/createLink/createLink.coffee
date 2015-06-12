Template.createLink.rendered = ->

Template.createLink.events
  'focusin #source, focusin #target': (e,t) ->
    $(e.currentTarget).next().toggleClass('hide')
  'focusout #source, focusout #target': (e,t) ->
    $(e.currentTarget).next().toggleClass('hide')

  'keyup #source': (e,t) ->
    Meteor.call 'getNodes', t.find('#source').value, (err,res) ->
      Session.set 'nodes', res

  'click li': (e,t) ->
    console.log "clicked?"
    console.log this
    console.log e.currentTarget

Template.createLink.helpers
  nodes: -> Session.get 'nodes'
