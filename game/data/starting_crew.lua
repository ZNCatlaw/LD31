local Task = game.classes.Task

local starting_crew = {
    captain = {
        tasks = {
            Task.new('wander'),
            Task.new('work', 'captain'),
            Task.new('porn')
        },
        walkspeed = 2,
        initial_task = 2
    },
    cto = {
        tasks = {
            Task.new('porn'),
            Task.new('work', 'cto'),
            Task.new('wander')
        },
        walkspeed = 2,
        initial_task = 2
    },
    engineer = {
        tasks = {
            Task.new('porn'),
            Task.new('work', 'engineer'),
            Task.new('wander')
        },
        walkspeed = 2,
        initial_task = 2
    },
    scientist = {
        tasks = {
            Task.new('porn'),
            Task.new('wander'),
            Task.new('work', 'scientist')
        },
        walkspeed = 2,
        initial_task = 3
    },
    operator = {
        tasks = {
            Task.new('work', 'operator'),
            Task.new('work', 'operator'),
            Task.new('wander')
        },
        walkspeed = 2,
        initial_task = 1
    }
}

return starting_crew
