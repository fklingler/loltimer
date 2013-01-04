Meteor.subscribe("monsters")
Meteor.autosubscribe ->
  Meteor.subscribe("timers", Session.get('room'))

## Rooms
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

## Timers
Template.page.monsters = ->
  Monsters.find()

Template.monster.time = ->
  timer = Timers.findOne(
    {
      monster: @_id,
      time: {$gt: new Date().getTime()}
    }
    sort:
      time: -1
  )
  timer.time if timer

# Display timers
Template.monster.rendered = ->
  if @_interval
    Meteor.clearInterval(@_interval)
    delete @_interval
  timer = this.find('.timer')
  time = timer.getAttribute('data-time')

  if time
    display_timer = (template) ->
      diff = Math.round((time - new Date().getTime()) / 1000)
      if diff <= 0
        diff = 0
        if template._interval
          Meteor.clearInterval(template._interval)
          delete template._interval
      minutes = Math.floor(diff/60)
      minutes = '0' + minutes if minutes < 10
      seconds = diff%60
      seconds = '0' + seconds if seconds < 10
      timer.innerHTML = minutes + ':' + seconds
    template = @
    display_timer(template)
    @_interval = Meteor.setInterval( ->
      display_timer(template)
    , 100)

Template.monster.destroyed = ->
  Meteor.clearInterval(@_interval)

# Create timers
create_timer = (monster, time_delta) ->
  seconds = monster.timer - time_delta
  time = new Date().getTime() + 1000 * seconds
  Meteor.call('createTimer', monster: monster._id, time: time, room: Session.get('room'), ->)

Template.monster.events
  'click input[type=button]': (event) ->
    create_timer @, event.currentTarget.getAttribute('data-time-delta')
  'keypress input[type=text]': (event) ->
    if event.which == 13 #enter
      create_timer @, event.currentTarget.value

# Remove timers
Template.page.events
  'click input.remove-all-timers': ->
    Meteor.call('removeTimers', Session.get('room'), ->)