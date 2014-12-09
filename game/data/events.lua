local event_rate = 5

local operator_barks = {
    "OPERATOR: Transporter room, ready to go.",
    "OPERATOR: I could transport you all into space right now if I wanted.",
    "OPERATOR: Hello?",
    "OPERATOR: Does anyone need anything transported? No?"
}

local captain_barks = {
    "CAPTAIN: Crew to the bridge!",
    "CAPTAIN: My cat's breath smells like cat food!",
    "CAPTAIN: Engage!",
    "CAPTAIN: Make it so!",
    "CAPTAIN: Tea, Earl Grey, Hot."
}

local event_messages = {
    scientist = {
        success = "SCIENTIST: Eureka! I have solved it!",
        failure = "SCIENTIST: But my calculations were perfect...",
        warning = "Space anomaly detected! Science officer to the science bay!",
        mia = "The scientist didn't arrive in time."
    },
    engineer = {
        success = "ENGINEER: All in a day's work...",
        failure = "ENGINEER: The engines won't hold!",
        warning = "Engine malfunction imminent! Engineer to engineering!",
        mia = "The engineer didn't arrive in time."
    },
    cto = {
        success = "CTO: This is a unix system... I know this!",
        failure = "CTO: Oh no! Off by one!",
        warning = "Malware detected! CTO to quantum super computer terminal!",
        porn = "CTO: Exposure to the internet seems to be affecting S.N.O.W.M.A.N.'s systems...",
        mia = "The CTO didn't arrive in time."

    },
    captain = {
        success = "CAPTAIN: Enemy neutralized. Excellent work, everyone.",
        failure = "CAPTAIN: We barely got away!",
        warning = "Enemy ships incoming! Captain on the bridge!",
        mia = "The captain didn't arrive in time."
    }
}

-- returns a random bark from the operator
local function operatorBark ()
    return operator_barks[love.math.random(1, #operator_barks)]
end

local function captainBark ()
    return captain_barks[love.math.random(1, #operator_barks)]
end

-- TODO station should be chosen randomly
local function damageShip (station)
    zigspect("event#damageShip", station)

    game.ship.stations[station]:damage()
    zigspect(game.ship.damage, game.ship.corruption)

    game.ui:addEventDialogue(event_messages["engineer"]["failure"], "engineer")

    return "DAMAGE TO " .. station
end

local function malfunctionShip (station)
    zigspect("event#malfunctionShip", station)

    game.ship.stations[station]:malfunction()
    zigspect(game.ship.damage, game.ship.corruption)

    game.ui:addEventDialogue(event_messages["cto"]["failure"], "cto")

    return "MALFUNCTION IN " .. station
end

local function damageSnowman ()
    game.ship.snowman:damage()
    zigspect(game.ship.snowman._damage)

    game.ui:addEventDialogue(event_messages["cto"]["porn"], "cto")

    return "DAMAGE TO SNOWMAN"
end

local events = {
    scientist = {
        success = function ()
            game.ui:addEventDialogue(event_messages["scientist"]["success"], 'scientist')
        end,
        fail = damageShip

    },
    engineer = {
        success = function ()
            game.ui:addEventDialogue(event_messages["engineer"]["success"], 'engineer')
        end,
        fail = damageShip
    },
    captain = {
        success = function ()
            game.ui:addEventDialogue(event_messages["captain"]["success"], 'captain')
        end,
        fail = damageShip
    },
    cto = {
        success = function ()
            game.ui:addEventDialogue(event_messages["cto"]["success"], 'cto')
        end,
        fail = malfunctionShip
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

    local randomBark = love.math.random(1, 5)
    if randomBark == 5 then
        game.ui:addEventDialogue(operatorBark(), 'operator')
    elseif randomBark >= 3 then
        game.ui:addEventDialogue(captainBark(), 'captain')
    end


    if event_messages[crew] then
        game.ui:addEventStatus(event_messages[crew]["warning"])
    end

    self.timer.add(event_rate, function ()
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
        if event_messages[self.current] then
            game.ui:addEventStatus(event_messages[self.current]["mia"], "negative")
        end
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
