game.classes = require('game/classes')
game.images = require('game/images')
game.data = require('game/data')
game.states = require('game/states')

game.events = game.data.events

love.mouse.setCursor(game.images.cursors.default)
Gamestate.switch(game.states.title)
