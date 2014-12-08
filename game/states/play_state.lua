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
    game.ship = game.classes.Ship.new({
        stations = game.data.stations,
        crew = game.data.starting_crew
    })

end

function state:leave()
end

function state:resume()
end

function state:getMouseTile(x,y)
    local r_scale =  love.viewport.r_scale
    local mouseX, mouseY = love.mouse.getPosition()
    mouseX = (mouseX - love.viewport.draw_ox) / r_scale
    mouseY = (mouseY - love.viewport.draw_oy) / r_scale

    local mapWidth = game.map.width
    local mapHeight = game.map.height

    local mouseTileX, mouseTileY = game.map:convertScreenToTile(mouseX, mouseY)
    mouseTileX = math.max(1, math.min(math.ceil(mouseTileX), mapWidth))
    mouseTileY = math.max(1, math.min(math.ceil(mouseTileY), mapHeight))

    return mouseTileX, mouseTileY
end

function state:getHighlightLayer(x, y)
    local mouseTileX, mouseTileY = self:getMouseTile(x, y)
    for k,v in pairs(game.map.layers) do
        local name = v.name
        if (name:find('_highlight') and v['data'][mouseTileY][mouseTileX]) then
            return name
        end
    end
end

function state:mousepressed(x, y, button)
    local room = self:getHighlightLayer(x, y)
    if room then
        room = room:gsub('_highlight','')
        timspect('CLICKED!', room, button)
    end
end

function state:update(dt)
    for _,star in ipairs(self.stars) do
        star.offset = star.offset + dt^star.velocity
    end

    self.highlightLayer = self:getHighlightLayer(love.mouse.getPosition())

    game.ship:update(dt)

    game.events:update(dt)

    if game.ship:shouldAsplode() then
        error("YOUR SHIP ASPLODE")
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

    if self.highlightLayer then
        love.mouse.setCursor(game.images.cursors.red)
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(251,79,20,32)
        game.map:drawTileLayer(self.highlightLayer)
        love.graphics.setColor(r,g,b,a)
    else
        love.mouse.setCursor(game.images.cursors.default)
    end
end

return state
