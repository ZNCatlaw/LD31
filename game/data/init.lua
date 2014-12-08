local data = {}

local path = ... .. "."

data.starting_crew = require(path..'starting_crew')
data.stations = require(path..'stations')
data.anims = require(path..'anims')
data.tasks = require(path..'tasks')

return data
