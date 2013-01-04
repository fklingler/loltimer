Meteor.publish "monsters", ->
  Monsters.find()

Meteor.publish "timers", (room) ->
  Timers.find({room: room})