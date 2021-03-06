local state = {}

local printMatrix = function (matrix)
    local w, h = #matrix, #(matrix[1])

    for i = 1, h do
        zigspect(i, matrix.map[i], matrix[i])
    end
end

function state:init()
    game.map = STI.new('assets/maps/test')
    game.map.graph = game.classes.Graph.new(game.map)

    -- build the sign posts
    game.map.graph:build()

    -- Set map and tileset filters
    local filter = conf.defaultImageFilter
    game.map.canvas:setFilter(unpack(filter))
    for _,v in ipairs(game.map.tilesets) do
        v.image:setFilter(unpack(filter))
    end

    local stars = {}
    local nStars = 400
    for i = 1,nStars do
        stars[i] = {}
        stars[i].x = love.math.random() * love.viewport.getWidth()
        stars[i].y = love.math.random() * love.viewport.getHeight()
        stars[i].size = 0.5 + love.math.random() * 1.5
        stars[i].velocity = 0.5 + love.math.random()
        stars[i].offset = 0
        stars[i].color = {love.math.random(225,255),
                          love.math.random(225,255),
                          love.math.random(225,255)}
    end
    self.stars = stars
end

function state:enter()
    game.ui = game.classes.UI.new()
    game.ship = game.classes.Ship.new({
        stations = game.data.stations,
        crew = game.data.starting_crew
    })

    TEsound.stop('music')
    TEsound.playLooping('assets/music/pulselooper-kalterkrieg.mp3', 'music', 0.5)
end

function state:leave()
end

function state:resume()
end

function state:keypressed(key)
    if (key == 'p' or key == 'q' or key == 'escape') then
        Gamestate.push(game.states.pause)
    elseif (key == ' ' or key == 'return') then
        self.ui.dialog:skipCurrent()
    end
end

function state:mousepressed(x, y, button)
    game.ui:mousepressed(x, y, button)
end

function state:focus(f)
    if not f then Gamestate.push(game.states.pause) end
end

function state:update(dt)
    for _,star in ipairs(self.stars) do
        star.offset = star.offset + dt^star.velocity
    end

    game.events:update(dt)
    game.ship:update(dt)
    game.ui:update(dt)

    local splode = game.ship:shouldAsplode()
    if splode then
        Gamestate.push(game.states.lose, splode)
    end
end

function state:draw()
    local r,g,b,a = love.graphics.getColor()
    for _,star in ipairs(self.stars) do
        local thisX = (star.x + star.offset) % love.viewport.getWidth()
        local thisY = (star.y + star.offset / 1.75) % love.viewport.getHeight()
        love.graphics.setColor(unpack(star.color))
        love.graphics.circle("fill", thisX, thisY, star.size, love.math.random(4,6))
    end
    love.graphics.setColor(r,g,b,a)

    game.map:draw()

    game.ship:draw()

    game.ui:draw()

end

return state
