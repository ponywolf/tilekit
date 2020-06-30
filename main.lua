-- Sample project for RXI loader

-- The default magnification sampling filter applied whenever an image is loaded by Corona.
-- Use "nearest" with a small content size to get a retro-pixel look
display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "linear")

-- set background color
display.setDefault("background", 34 / 255 ) -- match the blank tile

-- require the module
local tilekit = require "com.ponywolf.tilekit"

-- load the map and tileset image
local map = tilekit.load("dungeon.json", "colored_tilemap.png")

-- find an object
local hero = map.getObject("hero")

-- find a tile number at x,y
local tile = map.tile(10,10)

-- find that tiles tags
if map.tags(tile).wall then
  print ("This is a wall")
end


function map:touch( event )
  if event.phase == "began" then
    self.isFocus = true
    display.getCurrentStage():setFocus( event.target )
    self.markX = self.x    -- store x location of object
    self.markY = self.y    -- store y location of object
  elseif event.phase == "moved" and self.isFocus then
    local x = (event.x - event.xStart) + self.markX
    local y = (event.y - event.yStart) + self.markY
    self.x, self.y = x, y
  elseif event.phase == "ended"  or event.phase == "cancelled" then
    display.getCurrentStage():setFocus(nil)
    self.isFocus = false
  end
  return true
end

map:addEventListener("touch")