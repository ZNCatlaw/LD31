function love.conf(t)
    t.window.title = "S.N.O.W.M.A.N."

    t.window.resizable = false

    t.window.width = 1280
    t.window.height = 704
    t.window.minwidth  = t.window.width
    t.window.minheight = t.window.height
    t.window.highdpi = true

    _G.conf = t -- Makes configuration options accessible later
end
