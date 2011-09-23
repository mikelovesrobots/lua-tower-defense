ScreenManager = class('ScreenManager')
ScreenManager:include(Stateful)

function ScreenManager:initialize()
  debug("screenmanager initialized")
end

function ScreenManager:draw()
end

function ScreenManager.keypressed(key, unicode)
end

function ScreenManager.update(dt)
end

function ScreenManager.mousepressed(x, y, button)
end