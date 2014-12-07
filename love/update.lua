function love.update(dt)
    --Update here
    TEsound.cleanup()
    hump.Timer.update(dt)
    Gamestate.update(dt)
end
