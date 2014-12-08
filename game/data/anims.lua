local anim8 = kikito.anim8
local spriteSheet = game.images.peoplesprites
local g = anim8.newGrid(32, 32, spriteSheet:getWidth(), spriteSheet:getHeight(), 0, 0, 6)

local anims = {}

local walkspeed = 0.5

anims['captain'] = {
    image = spriteSheet,
    walkdown = anim8.newAnimation(g('7-9', 5), walkspeed),
    walkleft = anim8.newAnimation(g('7-9', 6), walkspeed),
    walkright = anim8.newAnimation(g('7-9', 7), walkspeed),
    walkup = anim8.newAnimation(g('7-9', 8), walkspeed),
}

anims['cto'] = {
    image = spriteSheet,
    walkdown = anim8.newAnimation(g('1-3', 5), walkspeed),
    walkleft = anim8.newAnimation(g('1-3', 6), walkspeed),
    walkright = anim8.newAnimation(g('1-3', 7), walkspeed),
    walkup = anim8.newAnimation(g('1-3', 8), walkspeed),
}

anims['engineer'] = {
    image = spriteSheet,
    walkdown = anim8.newAnimation(g('4-6', 5), walkspeed),
    walkleft = anim8.newAnimation(g('4-6', 6), walkspeed),
    walkright = anim8.newAnimation(g('4-6', 7), walkspeed),
    walkup = anim8.newAnimation(g('4-6', 8), walkspeed),
}

anims['scientist'] = {
    image = spriteSheet,
    walkdown = anim8.newAnimation(g('7-9', 1), walkspeed),
    walkleft = anim8.newAnimation(g('7-9', 2), walkspeed),
    walkright = anim8.newAnimation(g('7-9', 3), walkspeed),
    walkup = anim8.newAnimation(g('7-9', 4), walkspeed),
}

anims['operator'] = {
    image = spriteSheet,
    walkdown = anim8.newAnimation(g('10-12', 5), walkspeed),
    walkleft = anim8.newAnimation(g('10-12', 6), walkspeed),
    walkright = anim8.newAnimation(g('10-12', 7), walkspeed),
    walkup = anim8.newAnimation(g('10-12', 8), walkspeed),
}

return anims
