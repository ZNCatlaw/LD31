local state = {}

function state:init()
end

function state:enter()
    self.timer = hump.Timer.new()
    self.drawImages = {}
    self.interactive =  false
    self.flash = false

    self.timer.add(1, function() TEsound.playLooping('assets/music/2bithank-roygbiv.mp3', 'music') end)
    self.timer.add(2, function() table.insert(self.drawImages, game.images.znc) end)
    self.timer.add(3, function() table.insert(self.drawImages, game.images.titletext) end)
    self.timer.add(4, function()
        self.interactive = true

        self.flash = true
        self.timer.addPeriodic(0.5, function()
          self.flash = not self.flash
        end)
    end)
end

function state:leave()
    self.timer.clear()
    TEsound.stop('music')
end

function state:update(dt)
    self.timer.update(dt)
end

function state:draw()
    -- Always draw background with burnt-in snowman
    love.graphics.draw(game.images['background'])
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(r,g,b,12)
    love.graphics.draw(game.images['snowman'])
    love.graphics.setColor(r,g,b,a)

    for _,v in pairs(self.drawImages) do
        love.graphics.draw(v)
    end

    if self.flash then love.graphics.draw(game.images['clicktostart']) end
end

function state:keypressed(key)
    if (key == "escape" or key == "q") then
        love.event.quit()
    end
end

function state:mousepressed(x, y, button)
    if (self.interactive and button == 'l') then
        Gamestate.switch(game.states.play)
    end
end

--
return state
