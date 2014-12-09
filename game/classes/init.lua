local classes = {}

local path = ... .. "."

classes.Ship = require(path..'ship_class')
classes.Crew = require(path..'crew_class')
classes.Station = require(path..'station_class')
classes.Task = require(path..'task_class')
classes.Graph = require(path..'graph')
classes.Dialog = require(path..'dialog_class')
classes.DialogQueue = require(path..'dialog_queue_class')
classes.Snowman = require(path..'snowman')
classes.UI = require(path..'ui_class')

return classes
