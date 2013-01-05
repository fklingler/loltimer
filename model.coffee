# Deny insert, update, remove from client : must call server methods
Timers = new Meteor.Collection("timers")

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

  generateRoom: ->
    loop
      room = Math.random().toString(36).substr(2, 6)
      timers = Timers.find(room: room).count()
      break if timers == 0
    room
)