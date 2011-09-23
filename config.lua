app = {}
app.config = {
  UI_FONT = love.graphics.newFont("fonts/BOOTERFZ.ttf", 26),
  UI_LARGE_FONT = love.graphics.newFont("fonts/BOOTERFZ.ttf", 48),
  UI_MONEY_COLOR = {207,191,14},
  UI_LIVES_COLOR = {185,0,222},
  UI_TIMER_COLOR = {252,182,5},
  UI_CREEPS_LEFT_COLOR = {127,232,5},
  UI_SELECTED_TOWER_COLOR = {166,155,244},
  UI_HEALTHBAR_GOOD_COLOR={0,255,0},
  UI_HEALTHBAR_OKAY_COLOR={255,255,0},
  UI_HEALTHBAR_BAD_COLOR={255,0,0},
  REGULAR_FONT = love.graphics.newFont("fonts/VeraMono.ttf", 15),
  TILE_WIDTH = 64,
  TILE_HEIGHT = 64,
  TILE_CENTER_OFFSET = 32,
  ENEMY_WIDTH = 32,
  ENEMY_HEIGHT = 32,
  ENEMY_CENTER_OFFSET = 16,
  TIME_BETWEEN_WAVES = 6,
  TILES = {},
  PROJECTILE = {
    radius=3,
    speed=512
  },
  UI = {
    MONEY=love.graphics.newImage("images/ui/money.png"),
    LIVES=love.graphics.newImage("images/ui/lives.png"),
    TIMER=love.graphics.newImage("images/ui/timer.png"),
    WAVE=love.graphics.newImage("images/ui/wave.png"),
    WIN=love.graphics.newImage("images/screens/win.png"),
    LOSE=love.graphics.newImage("images/screens/lose.png")
  },
  CREEPS = {
    HORNET = {
      image = love.graphics.newImage("images/creeps/hornet.png"),
      speed = 128,
      hp = 5
    },
    LANTERN = {
      image = love.graphics.newImage("images/creeps/lantern.png"),
      speed = 64,
      hp = 10
    },
    SKULL = {
      image = love.graphics.newImage("images/creeps/skull.png"),
      speed = 96,
      hp = 15
    },
    KNIGHT = {
      image = love.graphics.newImage("images/creeps/knight.png"),
      speed = 64,
      hp = 20
    }
  },
  WAVES = {
    "HORNET",
    "LANTERN",
    "HORNET",
    "KNIGHT",
    "LANTERN",
    "SKULL",
    "HORNET",
    "LANTERN",
    "HORNET",
    "KNIGHT",
    "LANTERN",
    "SKULL"
  },
  WAVE_DIFFICULTY_INCREASE = 1.1,
  TOWERS = {
    ARROW = {
      image = love.graphics.newImage("images/towers/arrow.png"),
      ui = {
        x=800,
        y=100
      },
      damage = 10,
      radius = 192,
      cooldown = 0.5,
      cost = 10,
      splash = 0,
      slow = 0
    },
    ICE = {
      image = love.graphics.newImage("images/towers/ice.png"),
      ui = {
        x=900,
        y=100
      },
      damage = 15,
      radius = 192,
      cooldown = 0.4,
      cost = 20,
      splash = 8,
      slow = 16
    },
    SNIPER = {
      image = love.graphics.newImage("images/towers/sniper.png"),
      ui = {
        x=800,
        y=184
      },
      damage = 10,
      radius = 256,
      cooldown = 0.5,
      cost = 30,
      splash = 0,
      slow = 0
    },
    SUN = {
      image = love.graphics.newImage("images/towers/sun.png"),
      ui = {
        x=900,
        y=184
      },
      damage = 25,
      radius = 128,
      cooldown = 0.8,
      cost = 40,
      splash = 32,
      slow = 0
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
