local class = Class.new('Snowman')

function class:initialize(name, data)
    if(type(data) == 'table') then
        for k,v in pairs(data) do
            self[k] = (type(self[k]) == 'nil') and v or self[k]
        end
    end

    self._damage = 0
end

function class:repair()
    if self._damage > 0 then
        self._damage = self._damage - 1
    end
end

function class:damage()
    if self._damage < 7 then
        self._damage = self._damage + 1
    end
end

function class:getDamage()
    return self._damage
end

function class:mousepressed (room, button)
    if button == 'l' then
        -- send engineer to the room
        local crew = game.ship.crew['engineer']

        for i, station in pairs(game.ship.stations) do
            station.warning = false
        end

        game.ship.stations[room].warning = true

        crew:tryForceWander(crew.current_task, room)

    elseif button == 'r' then
        -- send cto to the room
        local crew = game.ship.crew['cto']

        for i, station in pairs(game.ship.stations) do
            station.buggy = false
        end

        game.ship.stations[room].buggy = true

        crew:tryForceWander(crew.current_task, room)
    end
end

function class:update(dt)

end

function class:draw()

end

--
return class
