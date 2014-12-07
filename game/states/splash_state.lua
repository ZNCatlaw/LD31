local state = {}

function state:init()
    local images = {}
    images['background'] = love.graphics.newImage('assets/images/title-bg.png')
    images['snowman'] = love.graphics.newImage('assets/images/title-snowman.png')
    images['titletext'] = love.graphics.newImage('assets/images/title-titletext.png')
    images['znc'] = love.graphics.newImage('assets/images/title-znc.png')
    self.images = images
end

function state:enter()
    love.soundman.playSoundLoop('assets/sounds/music-roygbiv.mp3')
end

function state:leave()
end

function state:resume()
end

function state:update()
end

function state:draw()
    love.graphics.draw(self.images['background'])

    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(r,g,b,18)
    love.graphics.draw(self.images['snowman'])
    love.graphics.setColor(r,g,b,a)

    love.graphics.draw(self.images['titletext'])
    love.graphics.draw(self.images['znc'])
end

--
return state
