local ui = Class('UI')

ui.TEXT_COLOR = {0, 255, 48, 255}
ui.HIGHLIGHT_COLOR = {251, 79, 20, 32}

function ui:initialize()
    self.statusbox = {
        x = game.map.tilewidth * 1,
        y = game.map.tileheight * 19,
        w = 6 * game.map.tilewidth,
        headerFont = game.images.fonts.statusHeader,
        messageFont = game.images.fonts.statusMessage,
        header = '',
        message = ''
    }

    self.warning = game.classes.DialogQueue.new()

    self.dialog = game.classes.DialogQueue.new()

    self.images = game.images.ui
end

function ui:getMouseTile(x,y)
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

function ui:getHighlightLayer(x, y)
    local mouseTileX, mouseTileY = self:getMouseTile(x, y)
    for k,v in pairs(game.map.layers) do
        local name = v.name
        if (name:find('_highlight') and v['data'][mouseTileY][mouseTileX]) then
            return name
        end
    end
end

function ui:mousepressed(x, y, button)
    local room = self:getHighlightLayer(x, y)
    if room then
        room = room:gsub('_highlight','')
        timspect('CLICKED!', room, button)

        game.ship.snowman:mousepressed(room, button)
    end
end

function ui:update(dt)
    self.warning:update(dt)
    self.dialog:update(dt)

    local statusbox = self.statusbox

    self.highlightLayer = self:getHighlightLayer(love.mouse.getPosition())
    if self.highlightLayer then
        local stationID = self.highlightLayer:gsub('_highlight','')
        local station = game.ship.stations[stationID]

        statusbox.header = station.niceName
        local msg = table.concat({
            station.occupancy[stationID] and " In use :)\n" or "Not in use\n",
            station:isDamaged() and "  DAMAGED\n" or "\n",
            station.warning and "    (WARNING SET)\n" or "\n",
            station:isMalfunction() and "  MALFUNCTIONING\n" or "\n",
            station.buggy and "    (BUGGY SET)\n" or "\n",
        })
        statusbox.message = msg
    else
        statusbox.header = ''
        statusbox.message = ''
    end
end

function ui:addEventDialogue (message, name)
    self.dialog:add({
        message = message,
        crew = name,
        color = {255, 255, 255, 255}
    })
end

function ui:addEventStatus (message, posture)
    local color = nil
    if(posture == 'positive') then
        color = {128, 128, 255, 255}
    elseif (posture == 'negative') then
        color = {255, 128, 128, 255}
    end


    self.warning:add({
        message = message,
        font = game.images.fonts.statusHeader,
        color = color
    })
end

function ui:drawMeter(c, units, x, y)
    if (units > 7) then return end
    for i=1,(7-units) do
        local str = 'bar_'..c..tostring(8-i)
        love.graphics.draw(self.images[str], x, y)
    end
end

function ui:draw()
    -- Title image
    love.graphics.draw(self.images.title, 32, 32)

    -- Highlight Layer
    if self.highlightLayer then
        love.mouse.setCursor(game.images.cursors.red)
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(ui.HIGHLIGHT_COLOR)
        game.map:drawTileLayer(self.highlightLayer)
        love.graphics.setColor(r,g,b,a)
    else
        love.mouse.setCursor(game.images.cursors.default)
    end

    -- Dialogue
    self.warning:draw(24, 256, 208)

    self.dialog:draw(32, 112, 400)

    -- Health Bar
    local barX = 3 * 32
    local barY = 11 * 32
    love.graphics.draw(self.images.bar_bg, barX, barY)
    love.graphics.draw(self.images.bar_snowman, barX, barY)
    love.graphics.draw(self.images.bar, barX, barY)

    self:drawMeter('g', game.ship.malfunction, barX, barY)
    self:drawMeter('r', game.ship.damage, barX, barY)
    self:drawMeter('b', game.ship.snowman:getDamage(), barX, barY)

    -- Status box
    local statusbox = self.statusbox
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(ui.TEXT_COLOR)
    local font = love.graphics.getFont()

    love.graphics.setFont(statusbox.messageFont)
    love.graphics.printf("Use Left & Right mouse buttons to direct the crew! Stay operational!", 32, 528, 192, 'center')

    love.graphics.setFont(statusbox.headerFont)
    love.graphics.printf(statusbox.header, statusbox.x, statusbox.y, statusbox.w)

    love.graphics.setFont(statusbox.messageFont)
    love.graphics.printf(statusbox.message, statusbox.x, statusbox.y + 18, statusbox.w)

    love.graphics.setFont(font)
    love.graphics.setColor(r,g,b,a)
end

--

return ui
