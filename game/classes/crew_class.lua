local class = Class.new('Crew')

function class:initialize(name, data)
    self.name = name
    if(type(data) == 'table') then
        for k,v in pairs(data) do
            self[k] = (type(self[k]) == 'nil') and v or self[k]
        end
    end
end

function class:update(dt)

end

function class:draw()

end

--
return class
