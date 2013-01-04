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
  Router.navigate(Session.get('room'), replace: true)

# Template values
Template.page.room = Template.room.room =  ->
  Session.get('room')

# Handle changing room
change_room = (room) ->
  Session.set('room', room) if room

generate_room = ->
  Meteor.call 'generateRoom', (error, result) ->
    change_room(result) unless error

# Create new room from homepage
Template.home.events
  'click input': ->
    generate_room()

# Room generate and change on room page
Template.room.events
  'click input.generate': ->
    generate_room()

  'blur input.room': (event) ->
    change_room(event.currentTarget.value)
  'keypress input.room': (event) ->
    if event.which == 13 #enter
      change_room(event.currentTarget.value)