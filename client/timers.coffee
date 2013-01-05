Meteor.subscribe("monsters")
Meteor.autosubscribe ->
  Meteor.subscribe("timers", Session.get('room'))

# Template values
Template.room.monsters_cols = ->
  MonstersCols

Template.monster.time = ->
  timer = Timers.findOne(
    {
      monster: @id,
      time: {$gt: new Date().getTime()}
    }
    sort:
      time: -1
  )
  timer.time if timer

# Display timers
Template.monster.rendered = ->
  if @_interval  # Cleaning
    Meteor.clearInterval(@_interval)
    delete @_interval

  # Get timestamp
  timer = this.find('.timer')
  time = timer.getAttribute('data-time')

  if time
    display_timer = (template) ->
      # Get seconds between timer and actual time
      diff = Math.round((time - new Date().getTime()) / 1000)
      if diff <= 0
        diff = 0
        if template._interval # Cleaning
          Meteor.clearInterval(template._interval)
          delete template._interval
      # Display minutes and seconds
      minutes = Math.floor(diff/60)
      minutes = '0' + minutes if minutes < 10
      seconds = diff%60
      seconds = '0' + seconds if seconds < 10
      timer.innerHTML = minutes + ':' + seconds

    # Display timer a first time then every 100ms
    template = @
    display_timer(template)
    @_interval = Meteor.setInterval( ->
      display_timer(template)
    , 100)

Template.monster.destroyed = ->
  # Cleaning
  Meteor.clearInterval(@_interval)

# Create timers
create_timer = (monster, time_delta) ->
  seconds = monster.timer - time_delta
  time = new Date().getTime() + 1000 * seconds
  Meteor.call('createTimer', monster: monster.id, time: time, room: Session.get('room'), ->)

Template.monster.events
  'click .timer-trigger': (event) -> # Buttons
    create_timer @, event.currentTarget.getAttribute('data-time-delta')
  'keypress input[type=text]': (event) -> # Custom time delta value
    if event.which == 13 #enter
      create_timer @, event.currentTarget.value

# Remove timers
Template.page.events
  'click button.remove-timers': ->
    Meteor.call('removeTimers', Session.get('room'), ->)