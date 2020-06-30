# TileKit for Solar2D
*tilekit* is a simple [TileKit](https://rxi.itch.io/tilekit) loader for [Solar2D](http://solar2d.com/) (formerly CoronaSDK)

![JSON via TileKit](https://img.itch.zone/aW1nLzM3MzM1MjkucG5n/original/NxjIjz.png)

**TileKit for Solar2D** loads a TileKit map as a Solar2D display object with a few helper functions. TileKit is unique because it uses a pattern matching system to decorate a map instead of placing each individual tile. Future versions of this library will include functions for decorating random maps with TileKit's ability to export rulesets as lua code.

![JSON via TileKit](https://img.itch.zone/aW1nLzM3MzM0ODYuZ2lm/original/0jfMfV.gif)

### Features

- [x] Loads .JSON exports from [TileKit](https://rxi.itch.io/tilekit)
- [x] Basic animated tiles
- [x] Helper functions for finding Objects, Tags, Tiles

### Quick Start Guide

```
-- set background color
display.setDefault("background", 34 / 255 ) -- match the blank tile

-- require the module
local tilekit = require "com.ponywolf.tilekit"

-- load the map and tileset image
local map = tilekit.load("dungeon.json", "colored_tilemap.png")
```

#### map

The returned object (map) is a displayGroup with all the tiles added. It also has a few helper functions to work with the tile data

```
-- manipulate the map
map.x, map.y = 100, 100
map.alpha = 0.7
```

#### map.getObject(name) & map.getObjects(name)

map.getObject() returns the first object with that name. map.getObjects() returns an array of objects, even if there is just one

```
-- find an object
local hero = map.getObject("hero")
```

#### map.tile(x,y)

map.tile(x,y) returns the tile number at a map x,y

```
-- find a tile number at x,y
local tile = map.tile(10,10)
```
#### map.tag(tile)

map.tag(tile) returns the tags of a tile number

```
-- find that tiles tags
if map.tags(tile).wall then
  print ("This is a wall")
end
```

You can chain those functions together as well

```
if map.tags(map.tile(10,10)).wall then
  print ("The tile at 10,10 is a wall")
end
```

#### map.data

A decoded table of the original data is available at map.data