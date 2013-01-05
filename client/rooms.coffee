# Get room from url
RouterClass = Backbone.Router.extend
  routes:
    ''      : 'room'
    ':room' : 'room'
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

# Handle changing room
change_room = (room) ->
  Session.set('room', room)

generate_room = ->
  Meteor.call 'generateRoom', (error, result) ->
    change_room(result) unless error

# Room generate and change on home and room page
room_events = 
  'click input.generate': ->
    generate_room()
  'blur input.room': (event) ->
    change_room(event.currentTarget.value)
  'keypress input.room': (event) ->
    if event.which == 13 #enter
      change_room(event.currentTarget.value)

Template.home.events room_events
Template.room.events room_events

Template.page.events
  'click h1': ->
    previous_room = Session.get('room')
    Session.set('previous_room', previous_room) if previous_room
    Session.set('room', '')
