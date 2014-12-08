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

function class:update(dt)
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
                -- pivot into the next direction
                self:setDirection(subsequent.directions[self.destination].direction)
            else
                -- facing is chosen by the station
            end
        end
    else
        self.destination = "engineer"
        -- work, download porn, what-have you
        if self.location ~= self.destination then
            self.progress = 0
            local current = game.map.graph.verts[self.location]
            love.debug.print(self.name)
            love.debug.print(self.destination)
            love.debug.print(current.directions)
            local direction = current.directions[self.destination].key
            local subsequent = game.map.graph.verts[direction]

            self.location = subsequent.name
            self.x = subsequent.x
            self.y = subsequent.y

            if self.location ~= self.destination then
                -- pivot into the next direction
                self:setDirection(subsequent.directions[self.destination].direction)
            else
                -- facing is chosen by the station
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

    self.currentAnim:draw(self.anims.image, thisX + offsetX, thisY + offsetY, 0, 1, 1, 0, 8)
end

--
return class
