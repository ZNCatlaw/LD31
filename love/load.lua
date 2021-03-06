function love.load()
    Gamestate.switch({})

    love.viewport = require('libs/viewport').newSingleton({
        width = conf.window.width,
        height = conf.window.height,
        multiple = 0.5,
        filter = conf.defaultImageFilter,
        fs = true,
        cb = function(params)
            local pScale = love.window.getPixelScale()
            if game.map then
                game.map:resize(love.window.getWidth() * pScale,
                                love.window.getHeight() * pScale)
                game.map.canvas:setFilter(unpack(conf.defaultImageFilter))
            end
        end
    })

    require('game')
end
