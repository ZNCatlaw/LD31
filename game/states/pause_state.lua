local state = {}

function state:init()
end

function state:enter(from)
  self.from = from
  TEsound.volume('music', 0.5)
end

function state:leave()
  TEsound.volume('music', 1)
end

function state:keypressed(key)
  if (key == 'p') then
    Gamestate.pop()
  elseif (key == 'escape') then
    love.event.quit()
  end
end

function state:update()
end

function state:draw()
  self.from:draw()

  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(128,128,128,96)
  game.map:drawTileLayer('screen_mask')
  love.graphics.setColor(r,g,b,a)

  game.map:drawTileLayer('modal')

  local font = love.graphics.getFont()
  local screenWidth = love.viewport.getWidth()
  local centerY = love.viewport.getHeight() / 2

  love.graphics.setFont(game.images.fonts.modalHeader)
  love.graphics.printf('PAUSED', 0, centerY - 64, screenWidth, "center")

  love.graphics.setFont(game.images.fonts.modalMessage)
  love.graphics.printf("Press 'P' to continue.\nPress 'ESC' to quit.", 0, centerY + 32, screenWidth, "center")

  love.graphics.setFont(font)
end

--
return state
