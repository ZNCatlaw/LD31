--
love.viewport = require('libs/viewport').newSingleton({
    width = conf.window.width,
    height = conf.window.height,
    multiple = 0.5,
    filter = {'linear', 'linear', 8},
    fs = true,
    cb = function(params)
        local pScale = love.window.getPixelScale()
        if map then
            map:resize(love.window.getWidth() * pScale,
                       love.window.getHeight() * pScale)
        end
    end
})

--
function love.draw()
    map:draw()
end
