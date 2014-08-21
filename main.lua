--
--  main.lua
--  Main entry-point for the file.
--

-- conf.lua -- Initial configuration (already loaded)
--   Exports:
--     love.conf(t) - ran already
--     conf (table of love configuration settings)


--
--  Load global libraries and such here.
--
Class      = require('vendor/class')
JSON       = require('vendor/dkjson')
Set        = require('vendor/set')
inspect    = require('vendor/inspect')
math.round = require('vendor/round')
require('vendor/deepcopy') -- table.copy and table.deepcopy

-- This table can store important "global" objects for the game
-- (and keep the global namespace cleaner)
game = {}

-- debug.lua -- Debug flags/output for Love2d
--   Exports:
--     love.debug, etc. (see file)
require('love/debug')

-- Set some debug flags here ('all' is special)
love.debug.setFlag('all')

-- load.lua -- Loaded on game start
--   Exports:
--     love.load()
require('love/load')

-- update.lua -- Update method
--   Exports:
--     love.update(dt)
require('love/update')

-- draw.lua -- Draw method
--   Exports:
--     love.viewport (Viewport instance)
--     love.draw()
require('love/draw')

-- input.lua -- Input callbacks
--   Exports:
--     love.inputman (Inputman instance)
--     love.inputpressed(state, value)
--     love.inputreleased(state, value)
--     love.joystickadded(k)
--     love.joystickremoved(j)
require('love/input')

-- sound.lua -- Sound methods
--   Exports:
--     love.soundman (Soundman instance)
require('love/sound')

-- events.lua -- Love2d Event processing
--   Exports:
--     love.processevents()
require('love/events')

-- misc.lua -- Miscellaneous Love2d events
--   Exports:
--     love.threaderror(thread, errorstr)
require('love/misc')

-- run.lua -- Main loop
--   Exports:
--     love.run()
require('love/run')