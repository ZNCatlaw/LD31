local printMatrix = function (matrix)
    local w, h = #matrix, #(matrix[1])

    for i = 1, w do
        zigspect(matrix[i])
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

    local name = true and getName(grid[y][x]) or x .. y

    table.insert(vert.edges, name)

    return true
end

local matrixFromMap = function (map)
    local grid = map.layers.walkable.data
    local w, h = #grid, #(grid[1])

    -- iterate over the tiles
    -- naturally y and x are the reverse of what we would
    -- like, so grid is index y, x rather than x, y
    for y, tile_row in ipairs(grid) do
        for x, tile in ipairs(tile_row) do
            local i = x + w*(y - 1) -- linear index for matrix

            if tile then
                -- next tile x and y
                local vert = {
                    x = x, y = y,
                    edges = {}
                }

                local nx, ny

                -- check in cardinal directions

                nx = x - 1
                if insertNeighbour(grid, vert, nx, y) then
                    local j = nx + w*(y - 1) -- linear index of neighbour for matrix

                    game.spaceship.graph.matrix[i][j] = 1
                end

                nx = x + 1
                if insertNeighbour(grid, vert, nx, y) then
                    local j = nx + w*(y - 1) -- linear index of neighbour for matrix

                    game.spaceship.graph.matrix[i][j] = 1
                end

                ny = y - 1
                if insertNeighbour(grid, vert, x, ny) then
                    local j = x + w*(ny - 1) -- linear index of neighbour for matrix

                    game.spaceship.graph.matrix[i][j] = 1
                end

                ny = y + 1
                if insertNeighbour(grid, vert, x, ny) then
                    local j = x + w*(ny - 1) -- linear index of neighbour for matrix

                    game.spaceship.graph.matrix[i][j] = 1
                end

                local name = true and getName(tile) or x .. y
                game.spaceship.graph.verts[name] = vert
            end
        end
    end
end

-- given an adjacency matrix A[][] returns a table
-- P containing the shortest path from nodes a to b
local shortestPath = function (adjacencies, a, b)
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

    visited[1] = 1

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

function love.load()
    require('game/controls')
    require('game/sounds')

    game.states.splash = require('game/states/splash_state')
    game.states.title = require('game/states/title_state')
    game.states.play = require('game/states/play_state')
    game.states.pause = require('game/states/pause_state')

    Gamestate.switch(game.states.play)

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


    --zigspect(shortestPath(matrix, 1, 3))

    local NORTH = { dx = 0, dy = -1 }
    local EAST = { dx = 1, dy = 0 }
    local SOUTH = { dx = 0, dy = 1 }
    local WEST = { dx = -1, dy = 0 }

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
    game.spaceship.graph.matrix = zeroMatrix(50*50, 50*50)
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
    matrixFromMap(Gamestate.current().map)

    game.spaceship.crew = {}
    table.insert(game.spaceship.crew, {
        name = "engineer",
        x = 100,
        y = 100,
        speed = 50,
        boredom = 0,
        station = "engineering",
        working = true,
        quarters = "q1", -- TODO need a clever labelling for quarters
        destination = "engineering",
        current = "engineering",
        next = nil
    })
end
