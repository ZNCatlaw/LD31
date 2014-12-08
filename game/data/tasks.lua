local tasks = {
    porn = {

    },
    work = {

    },
    wander = {

    },
    config = {
        -- divides dt, high values make changes to boredom slower
        -- with time_dilation of 10, every tick the boredom changes
        -- by a multiple of 0.0016
        time_dilation = 10,

        -- this multiplies the chance of a check occurring, so if
        -- check_frequency is 0.1 and boredom is 0.5 the chance of
        -- a task switch will be 0.05 (or 5%) per second
        check_frequency = 0.1,

        -- when boredom reaches 1 the crew member is most likely to switch
        -- this rate is multiplied by dt/time_dilation and added/subtracted
        -- to boredom
        rate = {
            increase = 1,
            decrease = 2
        }
    }
}

return tasks
