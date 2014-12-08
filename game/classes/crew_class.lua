local class = Class.new('Crew')

function class:initialize(name, data)

    self.name = name
    if(type(data) == 'table') then
        for k,v in pairs(data) do
            self[k] = (type(self[k]) == 'nil') and v or self[k]
        end
    end

    local vert = game.map.graph.verts[name]

    self.x = vert.x
    self.y = vert.y
    self.progress = 0
    self.location = name
    self.destination = name
    self.direction = DIRECTIONS[0][1]
end

function class:updateDestination (dt)
end

--  Error: game/classes/crew_class.lua:44: attempt to index a nil value
--  stack traceback:
--      game/classes/crew_class.lua:44: in function 'update'
--      game/classes/ship_class.lua:25: in function 'update'
--      game/states/play_state.lua:59: in function 'update'
--      love/update.lua:7: in function 'update'
--      love/run.lua:47: in function <love/run.lua:1>
--      [C]: in function 'xpcall'

function class:update(dt)
    if self.destination ~= self.location then
        -- walk in the current direction
        self.progress = self.progress + dt*10 -- TODO remove this 10
    else
        self.destination = "engineer"
        -- work, download porn, what-have you
    end

    if self.progress > 1 then
        self.progress = 0
        local current = game.map.graph.verts[self.location]
        local direction = current.directions[self.destination].key
        local subsequent = game.map.graph.verts[direction]

        self.x = subsequent.x
        self.y = subsequent.y

        self.location = subsequent.name
        self.direction = subsequent.directions[self.destination].direction
    end
end

function class:draw()
    love.graphics.circle("fill", 32*self.x, 32*self.y, 10)
end

--
return class
