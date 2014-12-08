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
end

function class:update(dt)

end

function class:draw()

end

--
return class
