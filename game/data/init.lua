local data = {}

local path = ... .. "."

data.starting_crew = require(path..'starting_crew')
data.stations = require(path..'stations')

return data
