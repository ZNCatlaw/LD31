local class = Class.new('Station')

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
    self.corrupt = false
end

function class:isDamaged()
    return self._damage
end

function class:damage()
    self._damage = true

    if game.ship.damage < 7 then
        game.ship.damage = game.ship.damage + 1
    end
end

function class:repair()
    self._damage = false

    if game.ship.damage > 0 then
        game.ship.damage = game.ship.damage - 1
    end
end

function class:malfunction()
    self.corrupt = true

    if game.ship.corruption < 7 then
        game.ship.corruption = game.ship.corruption + 1
    end
end

function class:repair()
    self.corrupt = false

    if game.ship.corruption > 0 then
        game.ship.corruption = game.ship.corruption - 1
    end
end

function class:update(dt)

end

function class:draw()

end

--
return class
