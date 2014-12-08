local Task = game.classes.Task

local starting_crew = {
    captain = {
        tasks = {
            Task.new('porn'),
            Task.new('wander'),
            Task.new('work', 'captain')
        },
        walkspeed = 2,
        initial_task = 3
    },
    cto = {
        tasks = {
            Task.new('porn'),
            Task.new('wander'),
            Task.new('work', 'cto')
        },
        walkspeed = 1.5,
        initial_task = 3
    },
    engineer = {
        tasks = {
            Task.new('porn'),
            Task.new('wander'),
            Task.new('work', 'engineer')
        },
        walkspeed = 1,
        initial_task = 3
    },
    scientist = {
        tasks = {
            Task.new('porn'),
            Task.new('wander'),
            Task.new('work', 'scientist')
        },
        walkspeed = 3,
        initial_task = 3
    },
    operator = {
        tasks = {
            Task.new('work', 'operator')
        },
        walkspeed = 0.5,
        initial_task = 1
    }
}

return starting_crew
