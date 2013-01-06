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
  timestamp = timer.getAttribute('data-timestamp')

  if timestamp
    timer_duration = timer.getAttribute('data-timer-duration')
    timer_alert    = timer.getAttribute('data-timer-alert')
    timer_initial_color = red:51,  green:51, blue:51
    timer_final_color   = red:255, green:0,  blue:0

    display_timer = (template) ->
      # Get seconds between timer and actual time
      diff = timestamp - new Date().getTime()
      diff_s = Math.round(diff/1000)
      diff_ms = diff%1000

      # Display minutes and seconds
      minutes = if diff_s > 0 then Math.floor(diff_s/60) else 0
      seconds = if diff_s > 0 then diff_s%60 else 0
      timer.innerHTML = time_string_from_minutes_and_seconds(minutes, seconds)

      # Change color of timer (look at colors.coffee)
      if diff_s > timer_alert || (diff_ms >= 0 && Math.floor(diff_ms/500) == 0) || (diff_ms < 0 && Math.floor(-diff_ms/500) == 1) ## Blink
        exp_percent = get_time_exp_percent(diff_s, timer_duration) # exponential function
        new_color = get_rgb_hash_percent(exp_percent, timer_initial_color, timer_final_color)
        timer.style.color = rgb_string_from_hash(new_color)
      else
        timer.style.color = rgb_string_from_hash(timer_initial_color)

      # Clean at the end
      if diff_s < -5
        # Reset timer color
        timer.style.color = rgb_string_from_hash(timer_initial_color)
        # Clean interval
        if template._interval
          Meteor.clearInterval(template._interval)
          delete template._interval

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