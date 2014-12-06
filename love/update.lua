--love.debug.setFlag("all")

function love.update(dt)
    --Update here
    for i = #(game.spaceship.crew), 1, -1 do
        local crew = game.spaceship.crew[i]

        love.debug.printIf("crew", crew.boredom)

        if crew.boredom >= 1 then
            crew.boredom = 1
            -- choose a new destination

            crew.destination = crew.quarters

        elseif crew.working == true then

            crew.boredom = crew.boredom + dt
        end

        if crew.destination ~= crew.current then
            -- TODO need to also check whether crew.direction is the same as crew.current at crew.destination
            -- in case someone changes their mind mid-path
            --
            -- wander off

            local next = game.spaceship.graph.verts[crew.current].directions[crew.destination]
            local direction = next.direction

            -- update position
            love.debug.printIf("current", crew.current)
            love.debug.printIf("next", next.key)
            love.debug.printIf("next", next.direction)

            crew.x = crew.x + crew.speed*direction.dx*dt
            crew.y = crew.y + crew.speed*direction.dy*dt

            -- recover the next room's vertex
            next_vert = game.spaceship.graph.verts[next.key]

            -- if we've arrived, update current
            local sq_distance = math.pow(crew.x - next_vert.x, 2) + math.pow(crew.y - next_vert.y, 2)

            love.debug.printIf("d", sq_distance)

            if sq_distance < 1 then
                crew.current = next.key
                love.debug.printIf("next", crew.current)
            end
        end
    end

    Gamestate.update(dt)
end
