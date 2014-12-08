local class = Class('DialogQueue')

function class:initialize(dialogs)
    self.dialogs = dialogs or {}
end

function class:add(dialog)
    if(type(dialog) == 'table') then
        table.insert(self.dialogs, dialog)
    end
end

function class:getCurrent()
    return self.dialogs[1]
end

function class:skipCurrent()
    local current = self:getCurrent()
    if type(current) == 'nil' then return end

    if current.skip then current:skip() end
end

function class:update(dt)
    local current = self:getCurrent()
    if type(current) == 'nil' then return end

    if current.finished then
        table.remove(self.dialogs, 1)
        return self:update(dt)
    end
    if current.update then current:update(dt) end
end

function class:draw(x, y, w)
    local current = self:getCurrent()
    if type(current) == 'nil' then return end

    if current.draw then current:draw(x, y, w) end
end

--

return class
