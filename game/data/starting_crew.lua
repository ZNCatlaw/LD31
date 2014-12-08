local Task = game.classes.Task

local starting_crew = {
    captain = {
        tasks = {
            Task.new('porn'),
            Task.new('wander'),
            Task.new('work')
        },
        walkspeed = 2,
    },
    cto = {
        tasks = {
            Task.new('porn'),
            Task.new('wander'),
            Task.new('work')
        },
        walkspeed = 1.5,
    },
    engineer = {
        tasks = {
            Task.new('porn'),
            Task.new('wander'),
            Task.new('work')
        },
        walkspeed = 1,
    },
    scientist = {
        tasks = {
            Task.new('porn'),
            Task.new('wander'),
            Task.new('work')
        },
        walkspeed = 3,
    },
    operator = {
        tasks = {
            Task.new('work')
        },
        walkspeed = 0.5,
    }
}

return starting_crew
