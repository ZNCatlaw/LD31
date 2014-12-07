function love.load()
    require('game/controls')
    require('game/sounds')

    game.states.splash = require('game/states/splash_state')
    game.states.title = require('game/states/title_state')
    game.states.play = require('game/states/play_state')
    game.states.pause = require('game/states/pause_state')

    Gamestate.switch(game.states.splash)

    love.viewport = require('libs/viewport').newSingleton({
        width = conf.window.width,
        height = conf.window.height,
        multiple = 0.5,
        filter = conf.defaultImageFilter,
        fs = true,
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
end
