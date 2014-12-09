local state = {}

function state:init()
end

function state:enter(from, splode)
  self.from = from
  self.splode = splode
  TEsound.volume('music', 0.5)
end

function state:leave()
  TEsound.volume('music', 1)
end

function state:keypressed(key)
  if (key == 'return') then
    Gamestate.switch(game.states.play)
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
  love.graphics.setColor(255,0,0,255)
  love.graphics.printf('YOUR SHIP ASPLODE', 0, centerY - 64, screenWidth, "center")
  love.graphics.setColor(r,g,b,a)

  love.graphics.setFont(game.images.fonts.modalMessage)
  local splode = self.splode

  love.graphics.setColor(128,255,128,255)
  love.graphics.printf('Malfunctions: '..splode.malfunction..'/7', 0, centerY - 16, screenWidth, "center")

  love.graphics.setColor(128,128,255,255)
  love.graphics.printf('Corruption: '..splode.corruption..'/7', 0, centerY + 8, screenWidth, "center")

  love.graphics.setColor(255,128,128,255)
  love.graphics.printf('Damage: '..splode.damage..'/7', 0, centerY + 32 , screenWidth, "center")

  love.graphics.setColor(r,g,b,a)
  love.graphics.printf("Press 'ENTER' to restart.\nPress 'ESC' to quit.", 0, centerY + 64, screenWidth, "center")

  love.graphics.setFont(font)
end

--
return state
