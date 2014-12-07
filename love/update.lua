--love.debug.setFlag("all")

function love.update(dt)
    --Update here
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

    Gamestate.update(dt)
end
