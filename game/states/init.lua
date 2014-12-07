local states = {}

local path = ... .. "."

states.title = require(path..'title_state')
states.play = require(path..'play_state')
states.pause = require(path..'pause_state')

return states
