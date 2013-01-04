Monsters = new Meteor.Collection("monsters")

Timers = new Meteor.Collection("timers")
Timers.allow(
  insert: (userId, timer) ->
    timer.monster && timer.time && timer.room
)

Rooms = new Meteor.Collection("rooms")
Rooms.allow(
  insert: ->
    true
)

Meteor.methods (
  createTimer: (options) ->
    unless options && options.monster && options.time && options.room
      throw new Meteor.Error(400, "Required parameter missing")
    Timers.remove(monster: options.monster, room: options.room)
    Timers.insert(monster: options.monster, time: options.time, room: options.room)

  removeTimers: (room) ->
    unless room
      throw new Meteor.Error(400, "Required parameter missing")
    Timers.remove(room: room)
)