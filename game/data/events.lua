local operator_barks = {
    "stuff",
    "operator",
    "says"
}

local event_messages = {
    scientist = "science problems",
    operator = "teleporter problems",
    engineer = "engine problems",
    cto = "technology problems",
    captain = "captaincy problems"
}

-- returns a random bark from the operator
local function operatorBark ()
    return operator_barks[love.math.random(1, #operator_barks)]
end

-- TODO station should be chosen randomly
local function damageShip (station)
    zigspect("event#damageShip", station)

    game.ship.stations[station]:damage()
    zigspect(game.ship.damage, game.ship.corruption)

    return "DAMAGE TO " .. station
end

local function corruptShip (station)
    zigspect("event#corruptShip", station)

    game.ship.stations[station]:malfunction()
    zigspect(game.ship.damage, game.ship.corruption)

    return "MALFUNCTION IN " .. station
end

local function damageSnowman ()
    game.ship.snowman:damage()
    zigspect(game.ship.snowman._damage)

    return "DAMAGE TO SNOWMAN"
end

local events = {
    scientist = {
        success = function ()
            return "science, yay!"
        end,
        fail = damageShip

    },
    engineer = {
        success = function () return "engineering, yay!" end,
        fail = damageShip

    },
    captain = {
        success = function () return "captaincy, yay!" end,
        fail = damageShip

    },
    cto = {
        success = function () return "technology, yay!" end,
        fail = corruptShip

    },
    operator = {
        success = operatorBark,
        fail = operatorBark
    }
}

events.timer = hump.Timer.new()
events.will_resolve = false
events.current = nil
events.averted = false

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
    local has_event = self:hasEvent()

    if has_event and self:willResolve() --[[ this is a countdown ]] then
        local resolution = self:resolve() -- this behaviour is set in crew update, either relief or damage

        love.debug.printIf("events", "resolution:", resolution)
    elseif has_event == false then
        -- if there is no current event, try to schedule one
        self:scheduleEvent(game.classes.Crew.randomName())

        love.debug.printIf("events", "scheduled:", self.message)
    end

    self.timer.update(dt)
end

function events:hasEvent ()
    return self.current ~= nil
end

function events:willResolve ()
    return self.will_resolve
end

function events:setAverted (averted, crew)
    self.agent = crew
    self.agent:setWaiting(true)

    self.averted = averted
end

function events:reset ()
    self.timer.clear()
    self.averted = false
    self.agent = nil
    self.will_resolve = false
    self.current = nil
    self.message = nil
end

function events:getEvent ()
    if self:hasEvent() == false then return nil end

    return {
        station = self.current
    }
end

function events:resolve ()
    local result = nil

    if self.averted then
        -- just return the bark
        if type(events[self.current].success) == "function" then
            result = events[self.current].success() -- operator barks etc
        else
            result = events[self.current].success
        end

        self.agent:setWaiting(false)
    else
        if type(events[self.current].fail) == "function" then
            result = events[self.current].fail(game.classes.Station.randomStation())
        else
            result = events[self.current].fail
        end
    end

    self:reset()

    return result
end

return events
