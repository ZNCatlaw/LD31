local class = Class('task')
local letters = { "a", "b", "c", "d", "e", "f", "g", "h" }

local function findAvailableSpot(location)
    local stations = game.ship.stations[location]
    local occupancy = stations.occupancy

    love.debug.printIf("task_class", "findAvailableSpot", location)
    love.debug.printIf("task_class", stations.occupancy)

    local spot = nil

    local count = 1
    for name, occupied in pairs(stations.occupancy) do
        count = count + 1
        love.debug.printIf("task_class", "  ", name, tostring(occupied))
        if spot == nil and not occupied and string.find(name, '_') then
            spot = name
        end
    end

    if count < stations.length + 1 then
        spot = location .. '_' .. letters[count]
        love.debug.printIf("task_class", count, spot)
    end

    love.debug.printIf("task_class", "  returning", spot)
    return spot
end

local getWorkLocation = function (self, crew_name)
    return crew_name
end

local getPornLocation = function (self, crew_name)
    local location = "quarters"

    return findAvailableSpot(location)
end

local getWanderLocation = function (self, crew_name, opts)
    love.debug.printIf("task_class", "getWanderLocation", self.name, crew_name, opts)

    local location

    if opts then
        location = opts.room
    else
        location = game.classes.Station.randomStation()
    end

    love.debug.printIf("task_class", "  location", location)

    return findAvailableSpot(location)
end

local performPorn = function (self, crew)
    -- engineer/cto fix porn
    if crew.name == "engineer" then
        game.ship.stations["quarters"]:repair()
    elseif crew.name == "cto" then
        game.ship.stations["quarters"]:debug()
    end

    if not game.ship.stations["quarters"]:isDamagedOrMalfunction() then
        -- the cto does no harm
        if crew.name ~= "cto" then
            game.ship.snowman:damage()
        end
    end
end

local performWork = function (self, crew, dt)
    -- engineer repairs damage to his station
    if crew.name == "engineer" then
        local engineering = game.ship.stations[crew.name]

        if not engineering:isMalfunction() then
            engineering:repair()
        end
    end

    -- engineer repairs damage to his station
    if crew.name == "cto" then
        local super_computer = game.ship.stations[crew.name]

        crew.work_progress = crew.work_progress + dt
        if crew.work_progress > game.data.tasks.work.cto.deporn_rate then
            zigspect("DEPORN")
            crew.work_progress = 0
            game.ship.snowman:repair()
        end

        if not super_computer:isMalfunction() then
            super_computer:debug()
        end
    end

    -- avert problems
    if game.events:hasEvent() then
        local event = game.events:getEvent()

        -- TODO shouldn't work if you aren't in the right location

        if event.station == crew.name then
            game.events:setAverted(true, crew) -- prevent the event
            -- TODO this should cause a flag to get set in the crew, so that they
            -- remain at the event location for a few ticks before ever checking
            -- for boredom again: this is so that they won't just bullet bounce
            -- off the event room like PING
        end
    end
end

local performWander = function (self, crew)
    if crew.name == "cto" then
        -- debug the current location
        zigspect(game.ship.stations, crew.location)
        local location = string.gsub(crew.location, "_.", "")
        game.ship.stations[location]:debug()
        game.ship.stations[location].buggy = false

    elseif crew.name == "engineer" then
        -- repair the current location
        zigspect(game.ship.stations, crew.location)
        local location = string.gsub(crew.location, "_.", "")
        game.ship.stations[location]:repair()
        game.ship.stations[location].warning = false
    end
end

function class:initialize(name, crew_name)
  self.name = name
  self.crew_name = crew_name

  if self.name == "work" then
      self.getLocation = getWorkLocation
      self.perform = performWork
  end
  if self.name == "porn" then
      self.getLocation = getPornLocation
      self.perform = performPorn
  end
  if self.name == "wander" then
      self.getLocation = getWanderLocation
      self.perform = performWander
  end

  self.boredom = 0
end

return class
