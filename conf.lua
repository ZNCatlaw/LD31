function love.conf(t)
    t.window.title = "S.N.O.W.M.A.N."

    t.window.resizable = false

    t.window.width = 1280
    t.window.height = 704
    t.window.highdpi = true
--    t.window.fsaa = 2 -- breaks the linux

    t.defaultImageFilter = {'linear', 'linear', 8}

    _G.conf = t -- Makes configuration options accessible later
end
