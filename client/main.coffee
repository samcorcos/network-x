Template.main.helpers
  isGraph: -> Session.get "isGraph"

Template.sideNav.rendered = ->
  Session.setDefault "results", []

Template.sideNav.helpers
  results: ->
    Session.get "results"

Template.personSearch.events
  'click button': (e,t) ->
    query = t.find('input').value
    Meteor.call "searchPeople", query, (err, res) ->
      Session.set "results", res
    $('input').val('')

Template.companySearch.events
  'click #cn-submit': (e,t) ->
    query = t.find('#company-name').value
    Meteor.call "searchCompany", query, undefined, (err, res) ->
      Session.set "results", res
    $('input').val('')

  'click #ci-submit': (e,t) ->
    query = t.find('#company-industry').value
    Meteor.call "searchCompany", undefined, query, (err, res) ->
      Session.set "results", res
    $('input').val('')
