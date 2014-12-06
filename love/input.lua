function love.keypressed(key)
    if(key == 'f10') then
        love.event.quit()
    elseif(key == 'f11') then
        love.viewport.setFullscreen()
        love.viewport.setupScreen()
    elseif(key == 'f12') then
    end

    Gamestate.keypressed(key)
end

function love.keyreleased(key)
    Gamestate.keyreleased(key)
end

function love.mousepressed(x, y, button)
    Gamestate.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    Gamestate.mousereleased(x, y, button)
end
