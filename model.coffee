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
  removeTimers: (room) ->
    unless room
      throw new Meteor.Error(400, "Required parameter missing")
    Timers.remove({room: room})
)