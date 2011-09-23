-- add a state to that class using addState, and re-define the method
local WinScreen = ScreenManager:addState('WinScreen')

function WinScreen:enterState()
end

function WinScreen:draw()
  love.graphics.setColor(255,255,255);
  love.graphics.draw(app.config.UI.WIN, 50, 100)

  love.graphics.setFont(app.config.UI_LARGE_FONT)
  love.graphics.printf("OMG! You won!", 450, 200, 550, 'center')
  love.graphics.printf("Press enter to quit", 450, 250, 550, 'center')
end

function WinScreen:update(dt)
end

function WinScreen:keypressed(key, unicode)
  if (key == "return") then
    love.event.push('q') -- quit the game
  end
end

function WinScreen:mousepressed(x,y,button)
end