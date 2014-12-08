function love.load()
    Gamestate.switch({})

    love.viewport = require('libs/viewport').newSingleton({
        width = conf.window.width,
        height = conf.window.height,
        multiple = 0.5,
        filter = conf.defaultImageFilter,
        fs = false,
        cb = function(params)
            local pScale = love.window.getPixelScale()
            local map = Gamestate.current().map
            if map then
                map:resize(love.window.getWidth() * pScale,
                           love.window.getHeight() * pScale)
                map.canvas:setFilter(unpack(conf.defaultImageFilter))
            end
        end
    })

    require('game')
end
