function love.draw()
    local map = Gamestate.draw()

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

    return map
end
