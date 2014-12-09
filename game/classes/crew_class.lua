local class = Class.new('Crew')

class.names = Set.new()

--love.debug.setFlag("crew_class")

function class:initialize(name, data)
    class.names:add(name)

    self.name = name
    if(type(data) == 'table') then
        for k,v in pairs(data) do
            self[k] = (type(self[k]) == 'nil') and v or self[k]
        end
    end

    self.anims = game.data.anims[name]
    self.currentAnim = self.anims['walkdown']

    local vert = game.map.graph.verts[name]

    self.x = vert.x
    self.y = vert.y
    self.progress = 0
    self.destination = name
    self.location = name

    self.current_task = self.tasks[self.initial_task]
    game.map.layers[self.name .. '_on'].visible = true

    self:setDirection(DIRECTIONS[0][1])
end

function class.randomName ()
    local size = class.names:size()
    local names = class.names:items()

    local index = love.math.random(1, size)

    return names[index]
end

function class:setDirection (direction)
    if (direction.dx == 1) then
        self.currentAnim = self.anims['walkright']
    elseif (direction.dx == -1) then
        self.currentAnim = self.anims['walkleft']
    elseif (direction.dy == -1) then
        self.currentAnim = self.anims['walkup']
    elseif (direction.dy == 1) then
        self.currentAnim = self.anims['walkdown']
    else
       self.currentAnim = self.anims['walkdown']
    end
    self.direction = direction
end

function class:setWaiting (waiting)
    self.waiting = waiting
end

function class:isWaiting ()
    return self.is_waiting
end

function class:accrueBoredom (current_task, dt)
    -- TODO check for conditions that cause boredom to accrue faster, like scientist in a crowded room
    local rate = game.data.tasks.config.rate
    local time_dilation = game.data.tasks.config.time_dilation
    local check_frequency = game.data.tasks.config.check_frequency

    -- increment boredom for the current station
    -- decrement boredom for the other stations
    local next_task = current_task
    local rnd = love.math.random()
    local may_switch = rnd < current_task.boredom*(dt*check_frequency)
    local switched = false

    --love.debug.printIf("crew_class", rnd, current_task.boredom)

    for i, task in ipairs(self.tasks) do
        local sign = (task.name == current_task.name) and rate.increase or -rate.decrease

        -- TODO boredom should decrease more slowly than it increases
        task.boredom = task.boredom + sign*(dt/time_dilation)
        task.boredom = math.min(math.max(task.boredom, 0), 1)

        --love.debug.printIf("crew_class", "  ", task.name, task.boredom, current_task.boredom)
        -- is may switch and has not switched and task being considered is less boring
        if not switched and may_switch and next_task == current_task and task.boredom < current_task.boredom then
            next_task = self:trySwitchingTasks(current_task, task)
        end
    end

    return next_task
end

function class:tryForceWander (current_task, room)
    local wander
    for i, task in ipairs(self.tasks) do
        if task.name == "wander" then
            wander = task
        end
    end

    next_location = wander:getLocation(self.name, { room = room })

    self:updateDestination(wander, next_location)
end

function class:trySwitchingTasks (current_task, task, opts)
    if opts then return self:tryForceWander(current_task, opts) end

    local damaged, malfunction, occupied = false, false, false
    local next_task = current_task, next_location

    love.debug.printIf("boredom", "-------------------------")
    love.debug.printIf("boredom", self.name, "attempt switch to", task.name)

    next_location = task:getLocation(self.name)

    -- can't do a thing at an occupied location
    occupied = (next_location == nil)

    -- can't work at a damaged station
    if task.name == "work" and self.name ~= "engineer" then
        damaged = game.ship.stations[next_location]:isDamaged()

        if damaged then
            love.debug.printIf("boredom", "couldn't work because damaged")
        end
    elseif task.name == "porn" and self.name ~= "engineer" then
        damaged = game.ship.stations["quarters"]:isDamaged()

        if damaged then
            love.debug.printIf("boredom", "couldn't porn because damaged")
        end
    end

    -- can't work at a buggy station
    if task.name == "work" and self.name ~= "cto" then
        malfunction = game.ship.stations[next_location]:isMalfunction()

        if damaged then
            love.debug.printIf("boredom", "couldn't work because malfunction")
        end
    elseif task.name == "porn" and self.name ~= "cto" then
        malfunction = game.ship.stations["quarters"]:isMalfunction()

        if damaged then
            love.debug.printIf("boredom", "couldn't porn because malfunction")
        end
    end

    -- it is occupied so choose something else
    love.debug.printIf("boredom", tostring(occupied), tostring(damaged), tostring(malfunction))
    if not (occupied or damaged or malfunction) then
        love.debug.printIf("boredom", "  switched to", task.name)
        next_task = task
        switched = true
    else
        love.debug.printIf("boredom", "  could not switch to", task.name)
    end

    return next_task
end

function class:setDestination(new_destination)
    zigspect(new_destination)
    local location = string.gsub(self.location, '_.', '')
    local station = string.gsub(new_destination, '_.', '')
    local old_station = string.gsub(self.destination, '_.', '')

    love.debug.printIf("crew_class", "setDestination", location, station)

    zigspect(location, self.location, self.destination, new_destination, station)

    -- might just be wandering the halls
    if game.ship.stations[location] then
        game.ship.stations[location].occupancy[self.location] = false
    end

    -- switch destinations, emptying out the old one
    game.ship.stations[station].occupancy[new_destination] = true
    game.ship.stations[old_station].occupancy[self.destination] = false

    self.destination = new_destination
end

function class:updateDestination (next_task, next_location)
    love.debug.printIf("crew_class", self.name, "switching to", next_task.name)
    -- there is something more exciting to do
    self.current_task = next_task

    if self.current_task.name ~= "work" then
        game.map.layers[self.name .. '_on'].visible = false
    end
    -- TODO this isn't deterministic, so we shouldn't be doing it twice
    -- probably we need to optimistically setDestination when we determine
    -- the natural next task above
    self:setDestination(next_location)

    -- love.debug.printIf("crew_class", "from", self.location, "towards", self.destination)
    if self.location ~= self.destination then
        self.progress = 0
        local current = game.map.graph.verts[self.location]
        local direction = current.directions[self.destination].key
        local subsequent = game.map.graph.verts[direction]

        self:setDirection(current.directions[self.destination].direction)
    end
end

function class:update(dt)

    --love.debug.printIf("crew_class", self.name, self.destination, self.location, self.current_task.name)

    if self.destination ~= self.location then
        -- walk in the current direction
        self.progress = self.progress + (dt * self.walkspeed)

        --love.debug.unsetFlag("boredom")
        self:accrueBoredom(self.current_task, dt)
        --love.debug.setFlag("boredom")

        if self.progress > 1 then
            self.progress = 0
            local current = game.map.graph.verts[self.location]
            local direction = current.directions[self.destination].key
            local subsequent = game.map.graph.verts[direction]

            self.location = subsequent.name
            self.x = subsequent.x
            self.y = subsequent.y

            if self.location ~= self.destination then
                --love.debug.printIf("crew_class", self.location, self.destination, subsequent.name)
                -- pivot into the next direction
                self:setDirection(subsequent.directions[self.destination].direction)
            else
                -- arrived
                -- facing is chosen by the station

                -- damage snowman when arriving at porn station
                if self.current_task.name == "porn" then
                    self.current_task:perform(self)
                end

                -- turn on monitors when arriving at functional stations
                if self.current_task.name == "work" then
                    if not game.ship.stations[self.name]:isDamagedOrMalfunction() then
                        game.map.layers[self.name .. '_on'].visible = true
                    end

                    if self.name == "cto" and not game.ship.stations[self.name]:isDamaged() then
                        game.ship.snowman:repair()
                    end
                end

                -- having arrived, maybe fix it?
                if self.current_task.name == "wander" then
                    self.current_task:perform(self)
                end
            end
        end
    else
        -- accrueboredom and determine possible next task
        local next_task = self:accrueBoredom(self.current_task, dt)
        if next_task == nil then
            error("NEXT TASK WAS NIL")
        end

        -- work, download porn, what-have you
        if self.current_task.name == "work" then
            self.current_task:perform(self)
        end

        if self:isWaiting() then return end

--      -- snowman's alerts can override natural switching of tasks
--      -- if the work task is less boring than the current task
--      -- TODO actually split the bugs and warnings into two almost identical blocks
--      if game.ship.snowman:hasAlert() then
--          if self.name == "cto" or self.name == "engineer" then
--              local alert = game.ship.snowman:getAlert()

--              self:reactTo(alert)

--              next_task = alert -- if it is something they WOULD do then override the natural next task
--          end
--      end

--      if game.ship.crew["captain"].hasCommands() then
--          if self.name ~= "captain" then
--              -- crew tries to switch to whatever the captain said

--              -- go to bridge or whatever
--          end
--      end

        if next_task and self.current_task ~= next_task then
            next_location = next_task:getLocation(self.name)
            self:updateDestination(next_task, next_location)
        end
    end

    self.currentAnim:update(dt)
end

function class:draw()
    local tileWidth = game.map.tilewidth
    local tileHeight = game.map.tileheight

    local currentVert = game.map.graph.verts[self.location]

    local thisX = self.x * tileWidth
    local thisY = self.y * tileHeight
    local offsetX = tileWidth * self.progress * self.direction.dx
    local offsetY = tileHeight * self.progress * self.direction.dy

    if self.location ~= self.destination then
        local ghostTile = game.map.graph.verts[self.destination]
        local ghostX = ghostTile.x * tileWidth
        local ghostY = ghostTile.y * tileWidth
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(128,128,128,160)
        self.anims['staticdown']:draw(self.anims.image, ghostX, ghostY, 0, 1, 1, 0, 8)
        love.graphics.setColor(r,g,b,a)
    end

    self.currentAnim:draw(self.anims.image, thisX + offsetX, thisY + offsetY, 0, 1, 1, 0, 8)
end

--
return class
