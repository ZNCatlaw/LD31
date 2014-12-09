local class = Class.new('Station')

class.names = {
    "captain", "cto", "engineer", "scientist", "quarters", "operator", "airlock"
}

function class.randomStation ()
    local size = #(class.names)

    local index = love.math.random(1, size)

    return class.names[index]
end

function class:initialize(name, data)
    self.name = name
    self.length = data.length or 8

    if(type(data) == 'table') then
        for k,v in pairs(data) do
            self[k] = (type(self[k]) == 'nil') and v or self[k]
        end
    end

    self.occupancy = {}
    self._damage = false
    self._malfunction = false

    self.count = 0
end

function class:isDamaged()
    return self._damage
end

function class:isDamagedOrMalfunction()
    return self._damage or self._malfunction
end

function class:isMalfunction()
    return self._malfunction
end

function class:damage()

    if self._damage == false then
        if game.ship.damage < 7 then
            game.ship.damage = game.ship.damage + 1
        end
    end

    self._damage = true
end

function class:repair()
    if self._damage == true then
        if game.ship.damage > 0 then
            game.ship.damage = game.ship.damage - 1
        end
    end

    self._damage = false
end

function class:malfunction()
    if self._malfunction == false then
        if game.ship.malfunction < 7 then
            game.ship.malfunction = game.ship.malfunction + 1
        end
    end

    self._malfunction = true
end

function class:debug()
    if self._malfunction == true then
        if game.ship.malfunction > 0 then
            game.ship.malfunction = game.ship.malfunction - 1
        end
    end

    self._malfunction = false
end

function class:update(dt)
    self.count = self.count + dt
end

function class:draw()
    local decorations = { 'none', }
    if self._malfunction then table.insert(decorations, self.name ..'_malfunction') end
    if self._damage then table.insert(decorations, self.name ..'_damage') end

    local drawLayer = decorations[math.ceil(self.count*2 % #decorations)]
    if drawLayer ~= 'none' then
        game.map:drawTileLayer(drawLayer)
    end
end

--
return class
