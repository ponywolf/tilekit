--- Tilekit loader for Solar2D

local json = require "json"

local M = {}

local function tilesetOptions(w,h,rows,cols,margin,spacing)
  if not w or not h then
    print("WARNING: Need tile w,h plus rows and columns")
  end
  margin, spacing = margin or 0, spacing or 0

  local options = { frames = {} }
  local frames = options.frames

  for j=0, cols-1 do
    for i=0, rows-1 do
      local element = {
        x = i * (w + spacing) + margin,
        y = j * (h + spacing) + margin,
        width = w,
        height = h,
      }
      frames[#frames+1] = element
    end
  end

  return options
end

function M.load(filename, tileset)
  -- load data
  filename = system.pathForFile(filename, system.ResourceDirectory)
  local data = json.decodeFile(filename)
  if not data then
    print("ERROR: File not found")
  end

  -- dump data
  print(json.prettify(data))

  local tilesheet = display.newImage(tileset)
  if not tilesheet then
    print("ERROR: Specify the tilesheet filename")
  end

  local tw, th = data.map.tile_w, data.map.tile_h
  local w, h = tilesheet.width, tilesheet.height
  local mw, mh = data.map.w, data.map.h
  local spacing = data.map.tile_spacing
  local rows = math.floor(w / (tw+spacing))
  local cols = math.floor(h / (th+spacing))

  local options = tilesetOptions(tw, th, rows, cols, 0, spacing)

  display.remove(tilesheet)
  tilesheet = graphics.newImageSheet(tileset, options)

  -- animations

  local animations = data.map.animations
  local sequence = {}
  if #animations then
    for i = 1, #animations do
      local animation = animations[i]
      local index = animation.idx
      sequence[index] = {
        name = "default",
        frames = animation.frames,
        time = animation.rate * #animation.frames,
        loopCount = 0,
      }
    end
  end

  -- render data
  local instance = display.newGroup()
  local tiles = data.map.data
  for j = 0, mh-1 do
    for i = 0, mw-1 do
      local index = j * mw + i + 1
      local tile = tiles[index]
      local sprite
      if tile ~= 0 then -- not blank
        if sequence[tile] then -- animated
          sprite = display.newSprite(instance, tilesheet, sequence[tile])
          sprite.x, sprite.y = i * tw, j * th
          sprite:setSequence("default")
          sprite:play()
        else
          sprite = display.newImage(instance, tilesheet, tile, i * tw, j * th)
        end
      end
      -- treat as old school 0,0 sprite
      if sprite then
        sprite.anchorX, sprite.anchorY = 0,0
      end
    end
  end

  local objects = data.map.objects or {}
  function instance:getObjects(name) -- get all objects with name
    local found = {}
    for i = 1, #objects do
      if objects[i].name == name then
        found[#found+1] = objects[i]
      end
    end
    return found
  end

  function instance.getObject(name) -- get first object with name
    if #objects then
      for i = 1, #objects do
        if objects[i].name == name then
          return objects[i]
        end
      end
    end	
  end

  function instance.getIds(id) -- get all objects with id
    local found = {}
    if #objects then
      for i = 1, #objects do
        if objects[i].id == id then
          found[#found+1] = objects[i]
        end
      end
    end
    return found
  end

  function instance.tile(x,y) -- get tile # at x,y
    return tiles[y * mw + x + 1]
  end

  local tags = data.map.tags or {}
  function instance.tags(tile) -- get tags from tile #
    local found = {}
    if #tags then
      for i = 1, #tags do
        for j = 1, #tags[i].tiles do
          if tags[i].tiles[j] == tile then
            found[tags[i].label] = true -- set that tag to true
          end
        end
      end
    end
    return found
  end

  instance.map = data.map
  return instance
end

return M