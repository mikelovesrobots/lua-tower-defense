-- add a state to that class using addState, and re-define the method
local Game = ScreenManager:addState('Game')
function Game:enterState()
  debug("Game initialized")

  self.lives = 8
  self.money = 20
  self.score = 0
  self.next_wave_dt = 10
  self.next_creep_dt = 0
  self.creeps_left = 0
  self.game_is_over = false

  self.selected_tower = nil
  self.hover_tile = nil
  self.towers = {}
  self.creeps = {}
  self.projectiles = {}
  self.current_wave = 0
end

function Game:keypressed(key, unicode)
  if (key == "q") then
    love.event.push('q') -- quit the game
  else
    debug("unmapped key:" .. key)
  end
end

function Game:draw()
  self:draw_map()
  self:draw_map_towers()
  self:draw_ui()
  self:draw_creeps()
  self:draw_projectiles()
end

function Game:update(dt)
  self:update_hover_tile(dt)
  self:update_release_creeps(dt)
  self:update_next_wave(dt)
  self:update_move_creeps(dt)
  self:update_remove_dead_creeps()
  self:update_fire_towers(dt)
  self:update_projectiles(dt)
  self:update_remove_dead_projectiles()
  self:update_game_end()
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

function Game:update_release_creeps(dt)
  self.next_creep_dt = self.next_creep_dt - dt
  if self.next_creep_dt < 0 and self.creeps_left > 0 then
    self.next_creep_dt = 0.5
    self:spawn_creep()
  end
end

function Game:spawn_creep()
    self.creeps_left = self.creeps_left - 1
    if self.creeps_left == 0 then
      self.next_wave_dt = app.config.TIME_BETWEEN_WAVES
    end

    local x, y = self:creep_target(1)
    local blueprint = app.config.CREEPS[app.config.WAVES[self.current_wave]]
    local maxhp = blueprint.hp * (self.current_wave ^ app.config.WAVE_DIFFICULTY_INCREASE)

    local creep = {
      x=x - app.config.TILE_WIDTH,
      y=y,
      target=1,
      remove=false,
      hp=maxhp,
      maxhp=maxhp,
      blueprint = blueprint
    }

    table.push(self.creeps, creep)
end

function Game:update_next_wave(dt)
  if self.creeps_left == 0 and #self.creeps == 0 then
    self.next_wave_dt = self.next_wave_dt - dt
    if self.next_wave_dt <= 0 then
      self.next_wave_dt = 0
      self.creeps_left = 10
      self.current_wave = self.current_wave + 1
    end
  end
end

function Game:update_move_creeps(dt)
  table.each(self.creeps, function(creep) self:move_creep(creep, dt) end)
end

function Game:update_projectiles(dt)
  table.each(self.projectiles, function(projectile)
                                 self:move_projectile(projectile, dt)
                               end)
end

function Game:update_game_end()
  if self.game_is_over then
    screen_manager:popState()
    screen_manager:pushState(self.next_screen)
  end
end

function Game:move_projectile(projectile, dt)
  local target_x = projectile.target.x + app.config.ENEMY_CENTER_OFFSET
  local target_y = projectile.target.y + app.config.ENEMY_CENTER_OFFSET
  local angle = math.angle(projectile.x, projectile.y, target_x, target_y)
  projectile.x, projectile.y = math.calc_destination(projectile.x, projectile.y, angle, app.config.PROJECTILE.speed * dt)
  if self:point_at_target(projectile.x, projectile.y, target_x, target_y) then
    self:projectile_hit_target(projectile)
  end
end

function Game:projectile_hit_target(projectile)
  projectile.remove = true
  self:damage_creep(projectile.target, projectile.tower.damage)
end

function Game:damage_creep(creep, damage)
  creep.hp = creep.hp - damage
  if creep.hp < 0 and not creep.remove then
    self:kill_and_reward_creep(creep)
  end
end

function Game:kill_and_reward_creep(creep)
  self:kill_creep(creep)
  self.money = self.money + self.current_wave
end

function Game:kill_creep(creep)
  creep.remove = true
end

function Game:update_remove_dead_creeps()
  self.creeps = table.reject(self.creeps, function(creep) return creep.remove end)
end

function Game:update_fire_towers(dt)
  table.each(self.towers, function(tower)
                            tower.cooldown = tower.cooldown - dt
                            if tower.cooldown < 0 and self:tower_has_target(tower) then
                              self:fire_tower(tower, self:tower_target(tower))
                            end
                          end)
end

function Game:update_remove_dead_projectiles()
  self.projectiles = table.reject(self.projectiles, function(projectile) return projectile.remove end)
end

function Game:tower_has_target(tower)
  local creep = self:tower_target(tower)
  if creep then
    return true
  else
    return false
  end
end

function Game:tower_target(tower)
  return table.detect(self.creeps, function(creep)
                                     local point_x, point_y = self:tile_to_point(tower.x, tower.y)

                                     if math.dist(point_x + app.config.TILE_CENTER_OFFSET, point_y + app.config.TILE_CENTER_OFFSET, creep.x, creep.y) < tower.blueprint.radius then
                                       return creep
                                     else
                                       return nil
                                     end
                                   end)
end

function Game:fire_tower(tower, target)
  self:spawn_projectile(tower, target)
  tower.cooldown = tower.blueprint.cooldown
end

function Game:spawn_projectile(tower, creep)
  local point_x, point_y = self:tile_to_point(tower.x, tower.y)

  local projectile = {
    x=point_x + app.config.TILE_CENTER_OFFSET,
    y=point_y + app.config.TILE_CENTER_OFFSET,
    target=creep,
    tower=tower.blueprint,
    remove=false
  }

  table.push(self.projectiles, projectile)
end

function Game:move_creep(creep, dt)
  local x, y = self:creep_target(creep.target)
  local angle = math.angle(creep.x, creep.y, x, y)
  creep.x, creep.y = math.calc_destination(creep.x, creep.y, angle, creep.blueprint.speed * dt)

  if self:creep_at_target(creep) then
    creep.target = creep.target + 1
    if creep.target > self:max_targets() then
      creep.remove = true
      self:lose_life()
    end
  end
end

function Game:lose_life()
  self.lives = self.lives - 1
  if self.lives < 0 then
    self:lose_game()
  end
end

function Game:lose_game()
  self.game_is_over = true
  self.next_screen = 'DeadScreen'
end

function Game:win_game()
  self.game_is_over = true
  self.next_screen = 'WinScreen'
end

function Game:creep_at_target(creep)
  local x, y = self:creep_target(creep.target)
  return self:point_at_target(x,y,creep.x,creep.y)
end

function Game:point_at_target(x1,y1,x2,y2)
  local diff_x = math.abs(x1 - x2)
  local diff_y = math.abs(y1 - y2)
  return diff_x < 4 and diff_y < 4
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

      local tile = map.layers[1].data[self:tile_to_map_data(x, y)]
      love.graphics.drawq(app.config.TILESET, app.config.TILES[tile], x * app.config.TILE_WIDTH, y * app.config.TILE_HEIGHT)
    end
  end
end

function Game:draw_map_towers()
  table.each(self.towers, function(tower)
                            local x, y = self:tile_to_point(tower.x, tower.y)
                            love.graphics.draw(tower.blueprint.image, x, y)
                          end)
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

function Game:draw_creeps()
  table.each(self.creeps, function(creep) self:draw_creep(creep) end)
end

function Game:draw_creep(creep)
  self:draw_creep_healthbar(creep, creep.hp, creep.maxhp)
  love.graphics.setColor(255,255,255)
  love.graphics.draw(creep.blueprint.image, creep.x, creep.y)
end

function Game:draw_creep_healthbar(creep, hp, maxhp)
  local percentage = hp / maxhp;
  if percentage > 0 then
    local hp_width = app.config.ENEMY_WIDTH * percentage
    local y = creep.y - 5

    if percentage < 0.5 then
      love.graphics.setColor(app.config.UI_HEALTHBAR_BAD_COLOR)
    elseif percentage >= 0.5 and percentage <= 0.75 then
      love.graphics.setColor(app.config.UI_HEALTHBAR_OKAY_COLOR)
    else
      love.graphics.setColor(app.config.UI_HEALTHBAR_GOOD_COLOR)
    end

    love.graphics.rectangle('fill', creep.x, y, hp_width, 1)
  end
end

function Game:draw_projectiles()
  table.each(self.projectiles, function(projectile) self:draw_projectile(projectile) end)
end

function Game:draw_projectile(projectile)
  love.graphics.circle('fill', projectile.x, projectile.y, app.config.PROJECTILE.radius)
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
    if self.selected_tower and self:can_afford_tower(self.selected_tower) and self:tile_available(tile_x, tile_y) then
      self:purchase_tower(self.selected_tower, tile_x, tile_y)
    end
  end
end

function Game:point_to_tile(x, y)
  local tile_x = math.floor(x / app.config.TILE_WIDTH)
  local tile_y = math.floor(y / app.config.TILE_HEIGHT)
  return tile_x, tile_y
end

function Game:tile_to_point(x, y)
  return x * app.config.TILE_WIDTH, y * app.config.TILE_HEIGHT;
end

function Game:point_within_tiles(x, y)
  return between(x, 0, map.width * app.config.TILE_WIDTH) and between(y, 0, map.height * app.config.TILE_HEIGHT)
end

function Game:tile_available(x, y)
  return not(self:tile_occupied(x, y) or self:tile_masked(x, y))
end

function Game:tile_occupied(x, y)
  return table.any(self.towers, function(tower) return tower.x == x and tower.y == y end)
end

function Game:tile_masked(x, y)
  return not(map.layers[2].data[self:tile_to_map_data(x, y)] == 0)
end

function Game:tile_to_map_data(x, y)
  return x + (y * map.layers[1].width) + 1
end

function Game:can_afford_tower(tower)
  return self.money >= app.config.TOWERS[tower].cost
end

function Game:purchase_tower(tower_name, x, y)
  local tower = {
    x=x,
    y=y,
    cooldown=0,
    blueprint=app.config.TOWERS[tower_name]
  }
  self.money = self.money - tower.blueprint.cost
  table.push(self.towers, tower)
end

function Game:creep_target(index)
  local object = map.layers[3].objects[index]
  if object then
    return object.x + app.config.ENEMY_CENTER_OFFSET, object.y + app.config.ENEMY_CENTER_OFFSET
  else
    return nil
  end
end

function Game:max_targets()
  return #map.layers[3].objects
end