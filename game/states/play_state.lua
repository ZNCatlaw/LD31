local state = {}

local printMatrix = function (matrix)
    local w, h = #matrix, #(matrix[1])

    for i = 1, h do
        zigspect(i, matrix.map[i], matrix[i])
    end
end

function state:init()
    self.map = STI.new('assets/maps/test')
    self.map.graph = game.Graph.new(self.map)

    -- build the sign posts
    self.map.graph:build()

    -- Set map and tileset filters
    local filter = conf.defaultImageFilter
    self.map.canvas:setFilter(unpack(filter))
    for _,v in ipairs(self.map.tilesets) do
        v.image:setFilter(unpack(filter))
    end

    local stars = {}
    local nStars = 400
    for i = 1,nStars do
        stars[i] = {}
        stars[i].x = love.math.random() * love.viewport.getWidth()
        stars[i].y = love.math.random() * love.viewport.getHeight()
        stars[i].size = 0.5 + love.math.random() * 1.5
        stars[i].velocity = 0.5 + love.math.random()
        stars[i].offset = 0
        stars[i].color = {love.math.random(225,255),
                          love.math.random(225,255),
                          love.math.random(225,255)}
    end
    self.stars = stars
end

function state:enter()
end

function state:leave()
end

function state:resume()
end

function state:update(dt)
    for _,star in ipairs(self.stars) do
        star.offset = star.offset + dt^star.velocity
    end
    self.map:draw()
end

function state:draw()
    local r,g,b,a = love.graphics.getColor()
    for _,star in ipairs(self.stars) do
        local thisX = (star.x + star.offset) % love.viewport.getWidth()
        local thisY = (star.y + star.offset / 1.75) % love.viewport.getHeight()
        love.graphics.setColor(unpack(star.color))
        love.graphics.circle("fill", thisX, thisY, star.size, love.math.random(4,6))
    end
    love.graphics.setColor(r,g,b,a)

    self.map:draw()
    self.map.graph:draw()

end

--[[
    TODO (this is for reference later)
    for i = #(self.map.crew), 1, -1 do
        local crew = map.crew[i]

        love.debug.printIf("crew", crew.boredom)

        if crew.destination ~= crew.current then
            -- TODO need to also check whether crew.direction is the same as crew.current at crew.destination
            -- in case someone changes their mind mid-path
            --
            -- wander off

            local next_node = map.graph.verts[crew.current]
            local directions = next_node.directions[crew.destination]

            -- if there is a way
            if directions then
                local direction = directions.direction

                -- update position

                crew.x = crew.x + crew.speed*direction.dx*dt
                crew.y = crew.y + crew.speed*direction.dy*dt

                -- recover the next room's vertex
                next_vert = map.graph.verts[directions.key]

                -- if we've arrived, update current
                local sq_distance = math.pow(crew.x - next_vert.x*16, 2) + math.pow(crew.y - next_vert.y*16, 2)

                if sq_distance < 1 then
                    crew.current = directions.key
                    love.debug.printIf("next", crew.current)
                end
            end
        else
            crew.destination = crew.station
        end
    end
--]]

return state
