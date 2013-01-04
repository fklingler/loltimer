Monsters = new Meteor.Collection("monsters")
Monsters.allow(
  insert: ->
    false
  update: ->
    false
  remove: ->
    false
)

Timers = new Meteor.Collection("timers")
Timers.allow(
  insert: ->
    true
  update: ->
    true
  remove: ->
    true
)