Meteor.publish "monsters", ->
  Monsters.find()

Meteor.publish "timers", ->
  Timers.find()