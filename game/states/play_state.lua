local state = {}

local directionFromDifference = function (from, to)
    local x = to.x - from.x
    local y = to.y - from.y

    return DIRECTIONS[x][y]
end

local createSignPosts = function (graph, matrix, path, finish)
    -- start at path[finish] and create the direction from finish to path[finish]
    -- then next is path[finish] to path[finish[finish]]

    local to = finish.label
    local from = path[finish.label]

    while from ~= nil do
        local to_node = graph[matrix.map[to]]
        local from_node = graph[matrix.map[from]]

        from_node.directions[finish.name] = {
            key = to_node.name,
            direction = directionFromDifference(from_node, to_node)
        }

        to = from
        from = path[to]
    end
end

local printMatrix = function (matrix)
    local w, h = #matrix, #(matrix[1])

    for i = 1, h do
        zigspect(i, matrix.map[i], matrix[i])
    end
end

local zeroMatrix = function (w, h)
    local matrix = {}

    for i = 1, w do
        matrix[i] = {}

        for j = 1, h do
            matrix[i][j] = 0
        end
    end

    return matrix
end

local getName = function (tile)
    local name = nil

    if tile.properties and tile.properties.name then
        name = tile.properties.name
    end

    return name
end

local insertNeighbour = function (grid, vert, x, y)
    if x < 1 or y < 1 or x > #grid or y > #(grid[1]) then return false end
    if grid[y][x] == false then return false end

    local name = true and getName(grid[y][x]) or tostring(x + (#grid)*(y - 1))

    table.insert(vert.edges, name)

    return true
end

local matrixFromMap = function (map)
    local grid = map.layers.walkable.data
    local w, h = #grid, #(grid[1])

    -- label the nodes
    local label = 0
    game.spaceship.graph.matrix.map = {}

    -- iterate over the tiles
    -- naturally y and x are the reverse of what we would
    -- like, so grid is index y, x rather than x, y
    for y, tile_row in ipairs(grid) do
        for x, tile in ipairs(tile_row) do

            if tile then
                label = label + 1

                -- add a vertex to the adjacencies
                if game.spaceship.graph.matrix[label] == nil then
                    game.spaceship.graph.matrix[label] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                end

                -- next tile x and y
                local vert = {
                    x = x, y = y,
                    edges = {},
                    directions = {},
                    label = label,
                    tile_number = x + w*(y - 1)
                }

                local nx, ny

                -- check in cardinal directions

                nx = x - 1
                insertNeighbour(grid, vert, nx, y)

                nx = x + 1
                insertNeighbour(grid, vert, nx, y)

                ny = y - 1
                insertNeighbour(grid, vert, x, ny)

                ny = y + 1
                insertNeighbour(grid, vert, x, ny)

                local name = true and getName(tile) or tostring(vert.tile_number)
                vert.name = name
                game.spaceship.graph.verts[name] = vert

                -- map to recover vert names from graph labels after dijkstra returns
                game.spaceship.graph.matrix.map[label] = name
            end
        end
    end

    -- populate the adjacency matrix
    for i, vert in pairs(game.spaceship.graph.verts) do
        local index = vert.label

        for j, edge_name in pairs(vert.edges) do
            local edge = game.spaceship.graph.verts[edge_name]

            local edge_label = edge.label

            game.spaceship.graph.matrix[index][edge_label] = 1
        end
    end
end

-- given an adjacency matrix A[][] returns a table
-- P containing the shortest path from nodes a to b
local shortestPath = function (adjacencies, a)
    local visited, d = {}, {}
    local path = {}

    -- initialize the visited table
    for i = 1, #adjacencies do
        visited[i] = 0

        -- initialize the edges coming from a
        d[i] = adjacencies[a][i]

        -- the path from any node next to a is clearly... a
        if d[i] > 0 then
            path[i] = a
        end
    end

    visited[a] = 1

    for i = 1, #adjacencies do
        local v   = nil
        local min = 1000 -- the longest possible path

        -- take the first unexplored node with an edge, and minimum weight
        local j = 1
        while (j <= #adjacencies) do
            if visited[j] == 0 and d[j] ~= 0 and d[j] <= min then
                min = d[j]
                v = j
            end
            j = j + 1
        end

        -- if there is a candidate
        if v ~= nil then
            visited[v] = 1

            -- adjust the distances of the other nodes
            for j = 1, #adjacencies do
                -- for each unexplored node with an edge to v,
                -- if the distance from s to j is less than
                -- the distance from s to v plus the distance from
                -- v to j, then decrease the distance
                if visited[j] == 0 and adjacencies[v][j] > 0 then
                    -- if there is an unexplored edge vj

                    -- at every step we mark the edge j as having
                    -- been arrived at via v

                    if d[j] == 0 then
                        d[j] = d[v] + adjacencies[v][j]
                        path[j] = v
                    elseif d[j] > d[v] + adjacencies[v][j] then
                        d[j] = d[v] + adjacencies[v][j]
                        path[j] = v
                    end
                end
            end
        end
    end

    return path
end

function state:init()
    self.map = STI.new('assets/maps/test')

    -- Set map and tileset filters
    local filter = conf.defaultImageFilter
    self.map.canvas:setFilter(unpack(filter))
    for _,v in ipairs(self.map.tilesets) do
        v.image:setFilter(unpack(filter))
    end

    -- ZIGGY THINGS
    --[[

    NORTH = { dx = 0, dy = -1 }
    EAST = { dx = 1, dy = 0 }
    SOUTH = { dx = 0, dy = 1 }
    WEST = { dx = -1, dy = 0 }

    DIRECTIONS = { }
    DIRECTIONS[-1] = { }
    DIRECTIONS[0] = { }
    DIRECTIONS[1] = { }

    DIRECTIONS[-1][0] = WEST
    DIRECTIONS[0][-1] = NORTH
    DIRECTIONS[0][1] = SOUTH
    DIRECTIONS[1][0] = EAST

    game.test_map = {}
    game.spaceship = {}

    -- each point on the graph contains directions
    -- to each other point (of interest) on the graph
    --
    -- simple ship example
    --
    -- E  -- h1
    --       |
    --       |
    -- q1 -- h2
    --
    -- the path will be in the form, for example
    -- { nil, 1, 2, 1, 4 }
    -- we will need a correspondence between numbers and names,
    -- we will need then to visit each vert and add an edge to that room
    -- and then use the positions of this room and that room to determine direction
    --
    game.spaceship.graph = {}
    game.spaceship.graph.matrix = {}
    game.spaceship.graph.verts = {
        engineering = {
            x = 100,
            y = 100,
            edges = { "h1" },
            directions = {
                q1 = {
                    key = "h1",
                    direction = EAST
                }
            },
        },
        q1 = {
            x = 100,
            y = 200,
            edges = { "h2" },
            directions = {
                engineering = {
                    key = "h2",
                    direction = EAST
                }
            }
        },
        h1 = {
            x = 200,
            y = 100,
            edges = { "engineering", "h2" },
            directions = {
                q1 = {
                    key = "h2",
                    direction = SOUTH
                },
                engineering = {
                    key = "engineering",
                    direction = WEST
                }
            }
        },
        h2 = {
            x = 200,
            y = 200,
            edges = { "q1", "h1" },
            directions = {
                q1 = {
                    key = "q1",
                    direction = WEST
                },
                engineering = {
                    key = "h1",
                    direction = NORTH
                }
            }
        }
    }

    game.spaceship.graph.verts = {}
    matrixFromMap(self.map)

    local named_verts = {}
    for key, vert in pairs(game.spaceship.graph.verts) do

        -- collect the named verts
        if tonumber(key) == nil then
            table.insert(named_verts, vert)
        end
    end

    -- for every named vert
    for i, finish in pairs(named_verts) do

        -- find all the shortest paths to it
        local path = shortestPath(game.spaceship.graph.matrix, finish.label)

        -- and then for every other named vert
        -- create a path of sign posts
        for j, start in pairs(named_verts) do

            if start ~= finish then
                createSignPosts(game.spaceship.graph.verts, game.spaceship.graph.matrix, path, start)
            end
        end
    end

    local start = game.spaceship.graph.verts["engineering"]
    local finish = game.spaceship.graph.verts["q1"]

    game.spaceship.crew = {}
    table.insert(game.spaceship.crew, {
        name = "engineer",
        x = start.x * 16,
        y = start.y * 16,
        speed = 16,
        boredom = 0,
        station = "engineering",
        working = true,
        quarters = "q1",
        destination = "q1",
        current = "engineering",
        next = nil
    })

    table.insert(game.spaceship.crew, {
        name = "bob",
        x = finish.x * 16,
        y = finish.y * 16,
        speed = 16,
        boredom = 0,
        station = "q1",
        working = true,
        quarters = "engineering",
        destination = "engineering",
        current = "q1",
        next = nil
    })

    ]]

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
    --Update here
    --[[
    for i = #(game.spaceship.crew), 1, -1 do
        local crew = game.spaceship.crew[i]

        love.debug.printIf("crew", crew.boredom)

        if crew.destination ~= crew.current then
            -- TODO need to also check whether crew.direction is the same as crew.current at crew.destination
            -- in case someone changes their mind mid-path
            --
            -- wander off

            local next_node = game.spaceship.graph.verts[crew.current]
            local directions = next_node.directions[crew.destination]

            -- if there is a way
            if directions then
                local direction = directions.direction

                -- update position

                crew.x = crew.x + crew.speed*direction.dx*dt
                crew.y = crew.y + crew.speed*direction.dy*dt

                -- recover the next room's vertex
                next_vert = game.spaceship.graph.verts[directions.key]

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
    ]]

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
    local map = self.map

    --[[
    for i, vert in pairs(game.spaceship.graph.verts) do

        love.graphics.circle("line", vert.x*16, vert.y*16, 2)

        for j, key in pairs(vert.edges) do
            local adjacency = game.spaceship.graph.verts[key]

            love.graphics.line(vert.x*16, vert.y*16, adjacency.x*16, adjacency.y*16)
        end
    end

    for i = #(game.spaceship.crew), 1, -1 do
        local crew = game.spaceship.crew[i]

        love.graphics.circle("fill", crew.x, crew.y, 10)
    end
    ]]
end

--
return state
