RouterClass = Backbone.Router.extend
  routes:
    ''      : 'room'
    ':room' : 'room'
  room: (room) ->
    if room
      Session.set('room', room)
    else
      Meteor.call 'generateRoom', (error, result) ->
        unless error
          console.log result
          Session.set('room', result)

Router = new RouterClass
Meteor.startup ->
  Backbone.history.start(pushState: true)

Meteor.autorun ->
  Router.navigate(Session.get('room'), replace: true)

Template.page.room = ->
  Session.get('room')

Template.page.events
  'blur input.room': (event) ->
    Session.set('room', event.currentTarget.value)
  'keypress input.room': (event) ->
    if event.which == 13 #enter
      Session.set('room', event.currentTarget.value)