--love.debug.setFlag("all")

function love.update(dt)
    TEsound.cleanup()
    hump.Timer.update(dt)
    Gamestate.update(dt)
end
