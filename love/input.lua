-- Maybe we want to use keypressed as well for a few global
--
function love.keypressed(key)
    if(key == 'f10') then
        love.event.quit()
    elseif(key == 'f11') then
        love.viewport.setFullscreen()
        love.viewport.setupScreen()
    elseif(key == 'f12') then
    end
end
