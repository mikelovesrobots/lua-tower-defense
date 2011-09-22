map = {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 12,
  height = 9,
  tilewidth = 64,
  tileheight = 64,
  properties = {
  },
  tilesets = {
    {
      name = "tilemap",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "tilemap.png",
      imagewidth = 2048,
      imageheight = 2048,
      tiles = {
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Background",
      x = 0,
      y = 0,
      width = 12,
      height = 9,
      visible = true,
      opacity = 1,
      properties = {
      },
      encoding = "lua",
      data = {
        388, 388, 387, 387, 387, 387, 387, 387, 387, 544, 527, 519,
        395, 400, 395, 400, 400, 409, 387, 387, 387, 551, 543, 555,
        387, 240, 229, 237, 385, 407, 400, 400, 400, 400, 415, 551,
        388, 235, 208, 233, 385, 385, 385, 385, 385, 387, 399, 387,
        388, 239, 234, 238, 385, 385, 385, 385, 385, 385, 399, 387,
        400, 401, 400, 405, 387, 385, 385, 385, 385, 385, 399, 387,
        387, 387, 388, 399, 388, 387, 387, 387, 387, 387, 399, 387,
        387, 387, 375, 407, 400, 400, 400, 400, 400, 400, 406, 387,
        387, 387, 387, 387, 387, 387, 387, 387, 387, 387, 387, 387
      }
    },
    {
      type = "tilelayer",
      name = "Masked",
      x = 0,
      y = 0,
      width = 12,
      height = 9,
      visible = true,
      opacity = 1,
      properties = {
      },
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        681, 681, 681, 681, 681, 681, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 681, 681, 681, 681, 681, 681, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 681, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 681, 0,
        681, 681, 681, 681, 0, 0, 0, 0, 0, 0, 681, 0,
        0, 0, 0, 681, 0, 0, 0, 0, 0, 0, 681, 0,
        0, 0, 0, 681, 681, 681, 681, 681, 681, 681, 681, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "Paths",
      visible = true,
      opacity = 1,
      properties = {
      },
      objects = {
        {
          name = "1",
          type = "",
          x = 0,
          y = 64,
          width = 64,
          height = 64,
          properties = {
          }
        },
        {
          name = "2",
          type = "",
          x = 320,
          y = 64,
          width = 64,
          height = 64,
          properties = {
          }
        },
        {
          name = "3",
          type = "",
          x = 320,
          y = 128,
          width = 64,
          height = 64,
          properties = {
          }
        },
        {
          name = "4",
          type = "",
          x = 640,
          y = 128,
          width = 64,
          height = 64,
          properties = {
          }
        },
        {
          name = "5",
          type = "",
          x = 640,
          y = 448,
          width = 64,
          height = 64,
          properties = {
          }
        },
        {
          name = "6",
          type = "",
          x = 192,
          y = 448,
          width = 64,
          height = 64,
          properties = {
          }
        },
        {
          name = "7",
          type = "",
          x = 192,
          y = 320,
          width = 64,
          height = 64,
          properties = {
          }
        },
        {
          name = "8",
          type = "",
          x = 0,
          y = 320,
          width = 64,
          height = 64,
          properties = {
          }
        }
      }
    }
  }
}
