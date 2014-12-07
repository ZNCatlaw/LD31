local DIRECTIONS = { }

local NORTH = { dx = 0, dy = -1 }
local EAST = { dx = 1, dy = 0 }
local SOUTH = { dx = 0, dy = 1 }
local WEST = { dx = -1, dy = 0 }

DIRECTIONS[-1] = { }
DIRECTIONS[0] = { }
DIRECTIONS[1] = { }

DIRECTIONS[-1][0] = WEST
DIRECTIONS[0][-1] = NORTH
DIRECTIONS[0][1] = SOUTH
DIRECTIONS[1][0] = EAST


local Graph, metatable = Class.new('Graph' )

local getName = function (grid, x, y)
    local name = nil
    local tile = grid[y][x]

    if tile.properties and tile.properties.name then
        name = tile.properties.name
    end

    return name == "path" and tostring(x + (#grid)*(y - 1)) or name
end

-- checks whether the given coords are on the given tilemap
-- inserts an edge in the given vertex if there is a vertex at x, y
local insertNeighbour = function (grid, vert, x, y)
    if x < 1 or y < 1 or x > #(grid[1]) or y > #grid then return false end
    if grid[y][x] == false then return false end

    local name = getName(grid, x, y)

    table.insert(vert.edges, name)

    return true
end

local zeroVector = function (w)
    local vector = {}

    for i = 1, w do
        vector[i] = 0
    end

    return vector
end

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
        local to_node = graph[matrix.names[to]]
        local from_node = graph[matrix.names[from]]

        from_node.directions[finish.name] = {
            key = to_node.name,
            direction = directionFromDifference(from_node, to_node)
        }

        to = from
        from = path[to]
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

local function buildVerts (map)
    local grid = map.layers.walkable.data
    local w, h = #grid, #(grid[1])

    -- label the nodes
    local label = 0

    -- adjacency_matrix and verts
    local verts, labels = {}, {}

    -- iterate over the tiles
    -- naturally y and x are the reverse of what we would
    -- like, so grid is index y, x rather than x, y
    for y, tile_row in ipairs(grid) do
        for x, tile in ipairs(tile_row) do

            if tile then
                label = label + 1

                -- next tile x and y
                local vert = {
                    x = x, y = y,
                    edges = {},
                    directions = {},
                    label = label,
                    tile_number = x + w*(y - 1)
                }

                local name = getName(grid, x, y)
                vert.name = name

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

                verts[name] = vert

                -- map to recover vert names from graph labels after dijkstra returns
                labels[label] = name
            end
        end
    end

    labels.length = label

    return verts, labels
end

function buildAdjecencyMatrix (verts, labels)
    local matrix = {}

    matrix.names = labels
    local length = labels.length

    -- populate the adjacency matrix
    for i, vert in pairs(verts) do
        local index = vert.label

        -- add a vertex to the adjacencies
        if matrix[index] == nil then
            matrix[index] = zeroVector(length)
        end

        -- populate that vertex's adjacencies
        for j, edge_name in pairs(vert.edges) do
            local edge = verts[edge_name]

            local edge_label = edge.label

            matrix[index][edge_label] = 1
        end
    end

    return matrix
end

function Graph:initialize (map)
    self.verts, labels = buildVerts(map)
    self.adjacency_matrix = buildAdjecencyMatrix(self.verts, labels)
end

-- creates the sign posts for guiding NPCs
function Graph:build ()
    local verts = self.verts
    local adjacency_matrix = self.adjacency_matrix

    local named_verts = {}
    local crew_verts = {}

    for key, vert in pairs(verts) do

        -- collect the named verts
        if tonumber(key) == nil then
            table.insert(named_verts, vert)
        end
    end

    -- for every named vert
    for i, finish in pairs(named_verts) do

        -- find all the shortest paths to it
        local path = shortestPath(adjacency_matrix, finish.label)

        -- and then for every other named vert
        -- create a path of sign posts
        for j, start in pairs(named_verts) do

            if start ~= finish then
                createSignPosts(verts, adjacency_matrix, path, start)
            end
        end
    end
end

-- mainly for debugging
function Graph:draw ()
    local verts = self.verts
    local length = 16
    local r = 2

    for i, vert in pairs(verts) do

        love.graphics.circle("line", vert.x*length, vert.y*length, r)

        for j, key in pairs(vert.edges) do
            local adjacency = verts[key]

            love.graphics.line(vert.x*length, vert.y*length, adjacency.x*length, adjacency.y*length)
        end
    end
end

return Graph
