-- add a state to that class using addState, and re-define the method
local DeadScreen = ScreenManager:addState('DeadScreen')

function DeadScreen:enterState()
end

function DeadScreen:draw()
  love.graphics.setColor(255,255,255);
  love.graphics.draw(app.config.UI.LOSE, 50, 100)

  love.graphics.setFont(app.config.UI_LARGE_FONT)
  love.graphics.printf("Death comes to us all", 450, 200, 550, 'center')
  love.graphics.printf("Press enter to quit", 450, 250, 550, 'center')
end

function DeadScreen:update(dt)
end

function DeadScreen:keypressed(key, unicode)
  if (key == "return") then
    love.event.push('q') -- quit the game
  end
end

function DeadScreen:mousepressed(x,y,button)
end