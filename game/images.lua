local images = {}

-- Titlescreen Images
images['background'] = love.graphics.newImage('assets/images/title-bg.png')
images['snowman'] = love.graphics.newImage('assets/images/title-snowman.png')
images['titletext'] = love.graphics.newImage('assets/images/title-titletext.png')
images['znc'] = love.graphics.newImage('assets/images/title-znc.png')
images['clicktostart'] = love.graphics.newImage('assets/images/title-clicktostart.png')

-- Spritesheets
images['peoplesprites'] = love.graphics.newImage('assets/maps/tilesets/peoplesprites.png')

-- Fonts
images.fonts = {}

images.fonts['dialog'] = love.graphics.newFont('assets/fonts/Commodore Angled v1.2.ttf', 18)
images.fonts['statusHeader'] = love.graphics.newFont('assets/fonts/Commodore Angled v1.2.ttf', 15)
images.fonts['statusMessage'] = love.graphics.newFont('assets/fonts/Commodore Angled v1.2.ttf', 12)

-- Cursors
images.cursors = {}

images.cursors['default'] = love.mouse.newCursor('assets/images/cursors/cursor0.png', 0, 0)
images.cursors['default_2x'] = love.mouse.newCursor('assets/images/cursors/cursor0_2x.png', 0, 0)

images.cursors['gold'] = love.mouse.newCursor('assets/images/cursors/cursor1.png', 0, 0)
images.cursors['gold_2x'] = love.mouse.newCursor('assets/images/cursors/cursor1_2x.png', 0, 0)

images.cursors['brown'] = love.mouse.newCursor('assets/images/cursors/cursor2.png', 0, 0)
images.cursors['brown_2x'] = love.mouse.newCursor('assets/images/cursors/cursor2_2x.png', 0, 0)

images.cursors['red'] = love.mouse.newCursor('assets/images/cursors/cursor3.png', 0, 0)
images.cursors['red_2x'] = love.mouse.newCursor('assets/images/cursors/cursor3_2x.png', 0, 0)

images.cursors['dark'] = love.mouse.newCursor('assets/images/cursors/cursor4.png', 0, 0)
images.cursors['dark_2x'] = love.mouse.newCursor('assets/images/cursors/cursor4_2x.png', 0, 0)

return images
