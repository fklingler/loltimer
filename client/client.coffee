Meteor.subscribe("monsters")
Meteor.autosubscribe ->
  Meteor.subscribe("timers", Session.get('room'))

Template.page.monsters = ->
  Monsters.find()

Template.page.room = ->
  Session.get('room')

Template.page.events (
  'blur input.room': (event) ->
    Session.set('room', event.currentTarget.value)
  'keypress input.room': (event) ->
    if event.which == 13 #enter
      Session.set('room', event.currentTarget.value)
)

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

Template.page.events "click input.remove-all-timers": ->
  Meteor.call('removeTimers', Session.get('room'))

Template.monster.events "click input": ->
  time = new Date().getTime() + 1000 * @timer
  Timers.insert(monster: @_id, time: time, room: Session.get('room'))