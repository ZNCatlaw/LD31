return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 5,
  height = 5,
  tilewidth = 16,
  tileheight = 16,
  properties = {},
  tilesets = {
    {
      name = "future_kitchen",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "tilesets/future_kitchen.png",
      imagewidth = 230,
      imageheight = 230,
      transparentcolor = "#ff00ff",
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      tiles = {
        {
          id = 17,
          properties = {
            ["name"] = "q1"
          }
        },
        {
          id = 47,
          properties = {
            ["name"] = "q2"
          }
        },
        {
          id = 52,
          properties = {
            ["name"] = "engineering"
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 5,
      height = 5,
      visible = false,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        51, 51, 51, 51, 51,
        51, 51, 51, 51, 51,
        51, 51, 51, 51, 51,
        51, 51, 51, 51, 51,
        51, 51, 51, 51, 51
      }
    },
    {
      type = "tilelayer",
      name = "walkable",
      x = 0,
      y = 0,
      width = 5,
      height = 5,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0,
        0, 25, 25, 25, 25,
        0, 25, 0, 0, 25,
        18, 25, 25, 0, 25,
        0, 0, 48, 0, 53
      }
    }
  }
}
