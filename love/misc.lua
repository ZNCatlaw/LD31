function love.resize(w, h)
    love.viewport.fixSize(w, h)
end

function love.threaderror(thread, errorstr)
    io.write('THREAD ERROR (', tostring(thread), '): ', errorstr, "\n")
end

function love.focus(f)
    Gamestate.focus(f)
end
