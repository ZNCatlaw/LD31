--
love.viewport = require('libs/viewport').newSingleton({
    width = 1280,
    height = 704,
    multiple = 0.5,
    filter = {'linear', 'linear', 16},
    fs = true,
    cb = function(params)
        if map then map:resize(love.window.getWidth(), love.window.getHeight()) end
    end
})

--
function love.draw()
    map:draw()
end
