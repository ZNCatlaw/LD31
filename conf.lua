function love.conf(t)
    t.window.title = "S.N.O.W.M.A.N. (v1.0-LD31)"

    t.window.resizable = false

    t.window.width = 1280
    t.window.height = 704
    t.window.highdpi = true

    t.defaultImageFilter = {'linear', 'linear', 8}

    _G.conf = t -- Makes configuration options accessible later
end
