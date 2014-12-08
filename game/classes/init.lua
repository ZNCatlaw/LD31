local classes = {}

local path = ... .. "."

classes.Ship = require(path..'ship_class')
classes.Station = require(path..'station_class')
classes.Crew = require(path..'crew_class')
classes.Task = require(path..'task_class')
classes.Graph = require(path..'graph')
classes.Snowman = require(path..'snowman')

return classes
