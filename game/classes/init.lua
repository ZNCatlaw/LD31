local classes = {}

local path = ... .. "."

classes.Ship = require(path..'ship_class')
classes.Station = require(path..'station_class')
classes.Crew = require(path..'crew_class')

return classes
