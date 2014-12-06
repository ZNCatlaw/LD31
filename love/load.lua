function love.load()
    require('game/controls')
    require('game/sounds')

    map = STI.new('assets/maps/test')

    -- Set map and tileset filters
    local filter = conf.defaultImageFilter
    map.canvas:setFilter(unpack(filter))
    for _,v in ipairs(map.tilesets) do
        v.image:setFilter(unpack(filter))
    end
end
