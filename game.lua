-- add a state to that class using addState, and re-define the method
local Game = ScreenManager:addState('Game')
function Game:enterState()
  debug("Game initialized")

  self.lives = 8
  self.money = 20
  self.score = 0
  self.next_wave_dt = 0
  self.creeps_left = 0
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
  self:draw_ui()
end

function Game:update(dt)
end


function Game:draw_map()
  love.graphics.setColor(255,255,255)
  for x=0,map.layers[1].width -1 do
    for y=0, map.layers[1].height - 1 do
      local tile = map.layers[1].data[x + (y * map.layers[1].width) + 1]
      love.graphics.drawq(app.config.TILESET, app.config.TILES[tile], x * app.config.TILE_WIDTH, y * app.config.TILE_HEIGHT)
    end
  end
end

function Game:draw_ui()

  love.graphics.setFont(app.config.UI_FONT);

  love.graphics.setColor(255,255,255)
  love.graphics.draw(app.config.UI.LIVES, 780, 15)
  love.graphics.setColor(app.config.UI_LIVES_COLOR);
  love.graphics.print(self.lives, 815, 12)

  love.graphics.setColor(255,255,255)
  love.graphics.draw(app.config.UI.TIMER, 880, 15)
  love.graphics.setColor(app.config.UI_TIMER_COLOR);
  love.graphics.print(math.floor(self.next_wave_dt), 915, 12)

  love.graphics.setColor(255,255,255)
  love.graphics.draw(app.config.UI.MONEY, 780, 55)
  love.graphics.setColor(app.config.UI_MONEY_COLOR);
  love.graphics.print(self.money, 815, 52)

  love.graphics.setColor(255,255,255)
  love.graphics.draw(app.config.UI.WAVE, 880, 55)
  love.graphics.setColor(app.config.UI_CREEPS_LEFT_COLOR);
  love.graphics.print(self.creeps_left, 915, 52)

  love.graphics.setColor(255,255,255)
  table.each({'ARROW','ICE','SNIPER','SUN'}, function(tower)
                                               local config = app.config.TOWERS[tower]
                                               love.graphics.draw(config.image, config.ui.x, config.ui.y)
                                             end)
end