local class = Class('task')
local letters = { "a", "b", "c", "d", "e", "f", "g", "h" }

local function findAvailableSpot(location)
    local stations = game.ship.stations[location]
    local occupancy = stations.occupancy

    zigspect("findAvailableSpot", location)
    zigspect(stations.occupancy)

    local spot = nil

    local count = 1
    for name, occupied in pairs(stations.occupancy) do
        count = count + 1
        zigspect("  ", name, tostring(occupied))
        if spot == nil and not occupied and string.find(name, '_') then
            spot = name
        end
    end

    if count < stations.length + 1 then
        spot = location .. '_' .. letters[count]
        zigspect(count, spot)
    end

    zigspect("  returning", spot)
    return spot
end

local getWorkLocation = function (self, crew_name)
    return crew_name
end

local getPornLocation = function (self, crew_name)
    local location = "quarters"

    return findAvailableSpot(location)
end

local getWanderLocation = function (self, crew_name)
    local location = game.classes.Crew.randomName()

    return findAvailableSpot(location)
end

function class:initialize(name, crew_name)
  self.name = name
  self.crew_name = crew_name

  if self.name == "work" then self.getLocation = getWorkLocation end
  if self.name == "porn" then self.getLocation = getPornLocation end
  if self.name == "wander" then self.getLocation = getWanderLocation end

  self.boredom = 0
end


return class
