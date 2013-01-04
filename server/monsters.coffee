monsters = [
  {
    name: 'Nashor'
    timer: 420
  },{
    name: 'Drake'
    timer: 360
  },{
    name: 'Allied Red'
    timer: 300
  },{
    name: 'Allied Blue'
    timer: 300
  },{
    name: 'Allied Golems'
    timer: 60
  },{
    name: 'Allied Wolves'
    timer: 60
  },{
    name: 'Allied Wraiths'
    timer: 50
  },{
    name: 'Enemy Red'
    timer: 300
  },{
    name: 'Enemy Blue'
    timer: 300
  },{
    name: 'Enemy Golems'
    timer: 60
  },{
    name: 'Enemy Wolves'
    timer: 60
  },{
    name: 'Enemy Wraiths'
    timer: 50
  }
]

Meteor.startup ->
  if Monsters.find().count() == 0
    Monsters.insert(monster) for monster in monsters
  