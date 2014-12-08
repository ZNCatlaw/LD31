local class = Class('Dialog')

function class:initialize(opts)
    if type(opts) ~= 'table' then opts = {} end

    self.message = opts.message or ''
    self.speed = opts.speed or 12

    self.anim = opts.anim or nil
    self.image = opts.image or nil
    self.font = opts.font or nil

    self.progress = 0

    --
    self.running = opts.running or true
    self.waitafter = opts.waitafter or 2
    self.persist = opts.persist or false

    -- Caret blinking
    self.caretrate = opts.caretrate or 0.5
    self.caretcount = 0

    self.finished = false
end

function class:start()
    self.progress = 0
    self.running = true
    self.finished = false
end

function class:skip()
    if self.running and not self.finished then
        if (self.progress < #self.message) then
            self.progress = #self.message
        else
            self.progress = #self.message + self.waitafter * self.speed
            self.persist = false
        end
    end
end

function class:finish()
    if not self.finished then
        self.progress = (#self.message + self.waitafter * self.speed)
        self.finished = true
    end
end

function class:update(dt)
    if not self.running then return end

    self.caretcount = self.caretcount + dt
    if (self.caretcount >= self.caretrate*2) then
        self.caretcount = 0
    end

    if self.anim then self.anim:update(dt) end

    self.progress = self.progress + self.speed * dt
    if self.progress > (#self.message + self.waitafter * self.speed) and not self.persist then
        self:finish()
    end
end

function class:draw(x, y, w)
    if self.finished then return end

    local msg = string.sub(self.message, 1, math.floor(self.progress))

    if self.caretcount >= self.caretrate then
      msg = msg..'_'
    end

    local offsetX = 0

    if self.anim then
        self.anim:draw(self.image, x, y)
        local _,_,w,_ = self.anim.frames[1]:getViewport()
        offsetX = w + 2
    elseif self.image then
        love.graphics.draw(self.image, x, y)
        offsetX = self.image:getWidth() + 2
    end

    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(0,255,64,255)
    local font = love.graphics.getFont()
    if self.font then love.graphics.setFont(self.font) end

    if w then
        love.graphics.printf(msg, x + offsetX, y, w - offsetX)
    else
        love.graphics.print(msg, x + offsetX, y)
    end
    love.graphics.setColor(r,g,b,a)

    love.graphics.setFont(font)
end

--

return class
