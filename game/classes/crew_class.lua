local class = Class.new('Crew')

class.names = Set.new()

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

    love.debug.printIf("crew_class", rnd, current_task.boredom)

    for i, task in ipairs(self.tasks) do
        local sign = (task.name == current_task.name) and rate.increase or -rate.decrease

        -- TODO boredom should decrease more slowly than it increases
        task.boredom = task.boredom + sign*(dt/time_dilation)
        task.boredom = math.min(math.max(task.boredom, 0), 1)

        love.debug.printIf("crew_class", "  ", task.name, task.boredom, current_task.boredom)
        -- is may switch and has not switched and task being considered is less boring
        if not switched and may_switch and next_task == current_task and task.boredom < current_task.boredom then
            love.debug.printIf("crew_class", "  attempt switch to", task.name)

            next_location = task:getLocation(self.name)

            -- it is occupied so choose something else
            if next_location ~= nil then
                love.debug.printIf("crew_class", "  switched to", task.name)
                next_task = task
                switched = true
            end
        end
    end

    return next_task
end

function class:setDestination(destination)
    local location = string.gsub(self.location, '_.', '')
    local station = string.gsub(destination, '_.', '')

    love.debug.printIf("crew_class", "setDestination", location, station)

    game.ship.stations[location].occupancy[self.location] = false
    game.ship.stations[station].occupancy[destination] = true

    self.destination = destination
end

function class:update(dt)
    love.debug.printIf("crew_class", self.name, self.destination, self.location, self.current_task.name)

    if self.destination ~= self.location then
        -- walk in the current direction
        self.progress = self.progress + (dt * self.walkspeed)

        if self.progress > 1 then
            self.progress = 0
            local current = game.map.graph.verts[self.location]
            local direction = current.directions[self.destination].key
            local subsequent = game.map.graph.verts[direction]

            self.location = subsequent.name
            self.x = subsequent.x
            self.y = subsequent.y

            if self.location ~= self.destination then
                love.debug.printIf("crew_class", self.location, self.destination, subsequent.name)
                -- pivot into the next direction
                self:setDirection(subsequent.directions[self.destination].direction)
            else
                -- facing is chosen by the station
            end
        end
    else
        -- accrueboredom and determine possible next task
        local next_task = self:accrueBoredom(self.current_task, dt)

--      -- work, download porn, what-have you
--      self.current_task:perform(function ()
--          -- TODO move this code to the perform method
--          -- if current_task is work
--          if self.current_task == "work" and game.events:hasEvents() then
--              local event = game.events:getEvent()

--              -- TODO shouldn't work if you aren't in the right location

--              if event.station == self.name then
--                  game.event:setAverted(true) -- prevent the event
--                  -- TODO this should cause a flag to get set in the crew, so that they
--                  -- remain at the event location for a few ticks before ever checking
--                  -- for boredom again: this is so that they won't just bullet bounce
--                  -- off the event room like PING
--              end
--          end
--      end)

--      -- snowman's alerts can override natural switching of tasks
--      -- if the work task is less boring than the current task
--      -- TODO actually split the bugs and warnings into two almost identical blocks
--      if game.snowman:hasAlert() then
--          if self.name == "cto" or self.name == "engineer" then
--              local alert = game.snowman:getAlert()

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

        if self.current_task ~= next_task then
            -- there is something more exciting to do
            self.current_task = next_task

            -- TODO this isn't deterministic, so we shouldn't be doing it twice
            -- probably we need to optimistically setDestination when we determine
            -- the natural next task above
            self:setDestination(self.current_task:getLocation(self.name))

            love.debug.printIf("crew_class", "from", self.location, "towards", self.destination)
            if self.location ~= self.destination then
                self.progress = 0
                local current = game.map.graph.verts[self.location]
                local direction = current.directions[self.destination].key
                local subsequent = game.map.graph.verts[direction]

                self:setDirection(current.directions[self.destination].direction)
            end
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
