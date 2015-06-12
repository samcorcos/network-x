Template.createLink.rendered = ->
  Session.setDefault 'settingSource', false
  Session.setDefault 'settingTarget', false

Template.createLink.events
  'focusin #source': (e,t) ->
    Session.set 'settingSource', true
  'focusout #source': (e,t) ->
    Session.set 'settingSource', false

  'focusin #target': (e,t) ->
    Session.set 'settingTarget', true
  'focusout #target': (e,t) ->
    Session.set 'settingTarget', false

Template.createLink.helpers
  settingSource: -> Session.get 'settingSource'
  settingTarget: -> Session.get 'settingTarget'
