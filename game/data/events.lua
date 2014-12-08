local operator_barks = {
    "stuff",
    "operator",
    "says"
}

local event_messages = {
    scientist = "",
    operator = "",
    cto = "",
    captain = ""
}

-- returns a random bark from the operator
local function operatorBark ()
    return operator_barks[love.math.random(1, #operator_barks)]
end

local function damageShip ()
    zigspect("DAMAGE TO SHIP")
end

local function damageSnowman ()
    zigspect("DAMAGE TO SNOWMAN")
end

local events = {
    scientist = {
        success = "yay",
        fail = damageShip

    },
    engineer = {
        success = "yay",
        fail = damageShip

    },
    captain = {
        success = "yay",
        fail = damageShip

    },
    cto = {
        success = "yay",
        fail = damageSnowman

    },
    operator = {
        success = operatorBark,
        fail = operatorBark
    }
}

events.timer = hump.Timer.new()
events.will_resolve = false
events.current = nil

-- a random event gets scheduled
function events:scheduleEvent (crew)
    self.current = crew
    self.message = event_messages[self.current]

    self.timer.add(5, function ()
        game.events:setWillResolve(true)
    end)
end

function events:setWillResolve (will_resolve)
    self.will_resolve = will_resolve
end

function events:update (dt)
    if self:hasEvent() and self:willResolve() --[[ this is a countdown ]] then
        self:resolve() -- this behaviour is set in crew update, either relief or damage
    else
        -- if there is no current event, try to schedule one
        self:scheduleEvent(game.classes.Crew.randomName())
    end

    self.timer.update(dt)
end

function events:hasEvent ()
    return self.current ~= nil
end

function events:willResolve ()
    return self.will_resolve
end

function events:resolve ()
    result = events[self.current].fail()
    self.timer.clear()
    self.will_resolve = false
    self.current = nil
    self.message = nil

    return result
end

return events
