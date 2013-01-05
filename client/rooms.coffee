# Get room from url
RouterClass = Backbone.Router.extend
  routes:
    ''      : 'room'
    '*room' : 'room'
  room: (room) ->
    Session.set('room', room)

Router = new RouterClass
Meteor.startup ->
  Backbone.history.start(pushState: true)

# Modify url when changing room
Meteor.autorun ->
  Router.navigate(Session.get('room'), trigger: true)

# Template values
Template.page.room = Template.room.room = ->
  Session.get('room')
Template.home.previous_room = ->
  Session.get('previous_room')


# Handle room generate and join
change_room = (room) ->
  Session.set('room', room) if room

events =
  # Create room (generate and join)
  'click button.create': ->
    Meteor.call 'generateRoom', (error, result) ->
      change_room(result) unless error
  # Generate room
  'click .generate': ->
    Meteor.call 'generateRoom', (error, result) ->
      $('input.room').val(result) unless error
  # Join room
  'click .join': (event) ->
    change_room($('input.room').val())
    event.preventDefault()
  'keypress input.room': (event) ->
    if event.which == 13 #enter
      change_room(event.currentTarget.value)
      event.preventDefault()

Template.home.events events
Template.room.events events

# Return on homepage
Template.page.events
  'click h1': ->
    previous_room = Session.get('room')
    Session.set('previous_room', previous_room) if previous_room
    Session.set('room', '')
