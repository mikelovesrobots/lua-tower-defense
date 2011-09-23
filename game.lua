-- add a state to that class using addState, and re-define the method
local Game = ScreenManager:addState('Game')
function Game:enterState()
  debug("Game initialized")

  self.lives = 8
  self.money = 20
  self.score = 0
  self.next_wave_dt = 0
  self.creeps_left = 0

  self.selected_tower = nil
  self.hover_tile = nil
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
  self:update_hover_tile(dt)
end

function Game:update_hover_tile(dt)
  local x, y = love.mouse.getPosition()
  if self:point_within_tiles(x, y) then
    local tile_x, tile_y = self:point_to_tile(x, y)
    self.hover_tile = {x=tile_x, y=tile_y}
  else
    self.hover_tile = nil
  end
end


function Game:draw_map()
  love.graphics.setColor(255,255,255)
  for x=0,map.layers[1].width -1 do
    for y=0, map.layers[1].height - 1 do
      if self.hover_tile and self.hover_tile.x == x and self.hover_tile.y == y then
        love.graphics.setColor(app.config.UI_SELECTED_TOWER_COLOR)
      else
        love.graphics.setColor(255,255,255)
      end

      local tile = map.layers[1].data[x + (y * map.layers[1].width) + 1]
      love.graphics.drawq(app.config.TILESET, app.config.TILES[tile], x * app.config.TILE_WIDTH, y * app.config.TILE_HEIGHT)
    end
  end
end

function Game:draw_ui()
  self:draw_ui_status_bar()
  self:draw_ui_tower_menu()
  self:draw_ui_tower_details()
end

function Game:draw_ui_status_bar()
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
end

function Game:draw_ui_tower_menu()
  table.each(table.keys(app.config.TOWERS), function(tower)
                                              if self.selected_tower == tower then
                                                love.graphics.setColor(app.config.UI_SELECTED_TOWER_COLOR)
                                              else
                                                love.graphics.setColor(255,255,255)
                                              end

                                              local config = app.config.TOWERS[tower]
                                              love.graphics.draw(config.image, config.ui.x, config.ui.y)
                                            end)
end

function Game:draw_ui_tower_details()
  if self.selected_tower then
    love.graphics.setColor(app.config.UI_SELECTED_TOWER_COLOR)
    love.graphics.print(self.selected_tower .. " TOWER", 800, 270)

    love.graphics.setColor(255,255,255)
    local attributes = {"cost", "damage", "radius", "cooldown", "splash", "slow"}
    table.each(attributes, function (attribute, i)
                             local y = 270 + (i * 30)
                             love.graphics.print(attribute, 800, y)
                             love.graphics.print(": " .. app.config.TOWERS[self.selected_tower][attribute], 900, y)
                           end)
  end
end

function Game:mousepressed(x, y, button)
  self:mousepressed_ui_towers(x, y, button)
  self:mousepressed_map(x, y, button)
end

function Game:mousepressed_ui_towers(x, y, button)
  table.each(table.keys(app.config.TOWERS), function(tower_name)
                                              local tower = app.config.TOWERS[tower_name]
                                              if between(x, tower.ui.x, tower.ui.x + app.config.TILE_WIDTH) and
                                              between(y, tower.ui.y, tower.ui.y + app.config.TILE_HEIGHT) then
                                                self.selected_tower = tower_name
                                              end
                                            end)
end

function Game:mousepressed_map(x, y, button)
  if self:point_within_tiles(x, y) then
    local tile_x, tile_y = self:point_to_tile(x, y)
    debug("tile clicked: " .. tile_x .. "x" .. tile_y)
  end
end

function Game:point_to_tile(x, y)
  local tile_x = math.floor(x / app.config.TILE_WIDTH)
  local tile_y = math.floor(y / app.config.TILE_HEIGHT)
  return tile_x, tile_y
end

function Game:point_within_tiles(x, y)
  return between(x, 0, map.width * app.config.TILE_WIDTH) and between(y, 0, map.height * app.config.TILE_HEIGHT)
end