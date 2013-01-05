Meteor.publish "timers", (room) ->
  Timers.find({room: room})