local state = {}

function state:init()
    self.map = STI.new('assets/maps/test_tileset')

    -- Set map and tileset filters
    local filter = conf.defaultImageFilter
    self.map.canvas:setFilter(unpack(filter))
    for _,v in ipairs(self.map.tilesets) do
      v.image:setFilter(unpack(filter))
    end
end

function state:enter()
end

function state:leave()
end

function state:resume()
end

function state:update()
end

function state:draw()
    self.map:draw()
end

--
return state
