-- add a state to that class using addState, and re-define the method
local Game = ScreenManager:addState('Game')
function Game:enterState()
  debug("Game initialized")

  local font = love.graphics.newFont("fonts/VeraMono.ttf", 13)
  love.graphics.setFont(font);
end

function Game:draw()
end

function Game:keypressed(key, unicode)
  if (key == "q") then
    screen_manager:popState()
  else
    debug("unmapped key:" .. key)
  end
end

function Game:draw()
  self:draw_map()
end

function Game:update(dt)
end


function Game:draw_map()
  for x=0,map.layers[1].width -1 do
    for y=0, map.layers[1].height - 1 do
      local tile = map.layers[1].data[x + (y * map.layers[1].width) + 1]
      love.graphics.drawq(app.config.TILESET, app.config.TILES[tile], x * app.config.TILE_WIDTH, y * app.config.TILE_HEIGHT)
    end
  end
end