require('middleclass')
require('middleclass-extras')
require('lua-enumerable')
require('extras')

require('screen_manager')
require('map')
require('config')
require('game')
require('win_screen')
require('dead_screen')

DEBUG = true

function love.load()
  math.randomseed( os.time() )
  screen_manager = ScreenManager:new() -- this will call initialize and will set the initial menu
  screen_manager:pushState('Game')
end

function love.draw()
  screen_manager:draw()
end

function love.update(dt)
  screen_manager:update(dt)
end

function love.keypressed(key, unicode)
  screen_manager:keypressed(key, unicode)
end

function love.mousepressed(x, y, button)
  screen_manager:mousepressed(x, y, button)
end