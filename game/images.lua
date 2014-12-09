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

images.fonts['modalHeader'] = love.graphics.newFont('assets/fonts/Commodore Angled v1.2.ttf', 36)
images.fonts['modalMessage'] = love.graphics.newFont('assets/fonts/Commodore Angled v1.2.ttf', 24)

-- UI
images.ui = {}
images.ui.title = love.graphics.newImage('assets/images/ui/title.png')
images.ui.bar = love.graphics.newImage('assets/images/ui/bar.png')
images.ui.bar_bg = love.graphics.newImage('assets/images/ui/bar_bg.png')
images.ui.bar_snowman = love.graphics.newImage('assets/images/ui/bar_snowman.png')
for i=1,7 do
  for _,v in ipairs({'r','g','b'}) do
    local str = v..tostring(i)
    images.ui['bar_'..str] = love.graphics.newImage('assets/images/ui/bar_'..str..'.png')
  end
end

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
