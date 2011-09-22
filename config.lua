app = {}
app.config = {
  MENU_TITLE_COLOR = {235, 10, 68},
  MENU_HIGHLIGHT_COLOR = {255, 179, 11},
  MENU_REGULAR_COLOR = {200, 200, 200},
  MENU_FONT = love.graphics.newFont("fonts/VeraMono.ttf", 15),
  TITLE_FONT = love.graphics.newFont("fonts/AngelicWar.ttf", 48),
  TILE_WIDTH = 64,
  TILE_HEIGHT = 64,
  ENEMY_WIDTH = 32,
  ENEMY_HEIGHT = 32,
  TILES = {},
  CREEPS = {
    HORNET = {
      image = love.graphics.newImage("images/creeps/hornet.png"),
      speed = 15,
      hp = 5
    },
    LANTERN = {
      image = love.graphics.newImage("images/creeps/lantern.png"),
      speed = 8,
      hp = 10
    },
    SKULL = {
      image = love.graphics.newImage("images/creeps/skull.png"),
      speed = 10,
      hp = 15
    },
    KNIGHT = {
      image = love.graphics.newImage("images/creeps/knight.png"),
      speed = 5,
      hp = 20
    }
  },

  TOWERS = {
    ARROW = {
      damage = 10,
      radius = 128,
      cooldown = 0.5,
      cost = 10,
      splash_radius = 0
    },
    ICE = {
      damage = 15,
      radius = 128,
      cooldown = 0.4,
      cost = 20,
      splash_radius = 8
    },
    SNIPER = {
      damage = 10,
      radius = 256,
      cooldown = 0.5,
      cost = 30,
      splash_radius = 0
    },
    SUN = {
      damage = 25,
      radius = 96,
      cooldown = 0.8,
      cost = 40,
      splash_radius = 32
    }
  },
  TILES = { },
  TILESET = love.graphics.newImage("tilemap.png")
}

-- load tiles
local tiles_per_row = map.tilesets[1].imagewidth / map.tilewidth
table.each(map.layers[1].data, function(tile)
                                 local adjusted_tile = tile - 1
                                 local x = (adjusted_tile % tiles_per_row)
                                 local y = math.floor(adjusted_tile / tiles_per_row)
                                 app.config.TILES[tile] = love.graphics.newQuad(x * 64, y * 64, app.config.TILE_WIDTH, app.config.TILE_HEIGHT, map.tilesets[1].imagewidth, map.tilesets[1].imageheight)
                               end)
