local state = {}

local timer = hump.Timer.new()
local drawImages = {}

local function playTitleMusic()
  TEsound.playLooping("assets/sounds/music-roygbiv.mp3", "music")
end

function state:init()
end

function state:enter()
    count = 0
    drawImages = {}

    timer.add(1, playTitleMusic)
    timer.add(2, function() table.insert(drawImages, game.images.znc) end)
    timer.add(3, function() table.insert(drawImages, game.images.titletext) end)
end

function state:leave()
    timer.clear()
    TEsound.stop('music')
end

function state:resume()
end

function state:update(dt)
  timer.update(dt)
end

function state:draw()
    -- Always draw background with burnt-in snowman
    love.graphics.draw(game.images['background'])
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(r,g,b,12)
    love.graphics.draw(game.images['snowman'])
    love.graphics.setColor(r,g,b,a)

    for _,v in pairs(drawImages) do
        love.graphics.draw(v)
    end
end

--
return state
