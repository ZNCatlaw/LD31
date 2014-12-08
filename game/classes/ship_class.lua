local class = Class.new('Ship')

function class:initialize(opts)
    self.stations = {}
    if(type(opts.stations) == 'table') then
        for k,v in pairs(opts.stations) do
            self.stations[k] = game.classes.Station.new(k, v)
        end
    end

    self.crew = {}
    if(type(opts.crew) == 'table') then
        for k,v in pairs(opts.crew) do
            self.crew[k] = game.classes.Crew.new(k, v)
            self.stations[k].occupancy[k] = true
        end
    end

    self.snowman = game.classes.Snowman.new()

    self.damage = 0
    self.corruption = 0
end

function class:shouldAsplode()
    zigspect(self.snowman:getDamage(), self.damage, self.corruption)
    return self.snowman:getDamage() == 7 or self.corruption == 7 or self.damage == 7
end

function class:update(dt)
    for name,obj in pairs(self.stations) do
        obj:update(dt)
    end

    for name,obj in pairs(self.crew) do
        obj:update(dt)
    end
end

function class:draw()
    for name,obj in pairs(self.stations) do
        obj:draw()
    end

    for name,obj in pairs(self.crew) do
        obj:draw()
    end
end

--
return class
