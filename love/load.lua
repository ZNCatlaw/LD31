function love.load()
    require('game/controls')
    require('game/sounds')


    local NORTH = { dx = 0, dy = -1 }
    local EAST = { dx = 1, dy = 0 }
    local SOUTH = { dx = 0, dy = 1 }
    local WEST = { dx = -1, dy = 0 }

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
    game.spaceship.graph = {}
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
