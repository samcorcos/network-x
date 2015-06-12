Template.createLink.rendered = ->
  Session.setDefault 'settingSource', false

Template.createLink.events
  'focusin #source': (e,t) ->
    Session.set 'settingSource', true
  'focusout #source': (e,t) ->
    Session.set 'settingSource', false

Template.createLink.helpers
  settingSource: -> Session.get 'settingSource'
