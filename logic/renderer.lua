local Renderer = {}

function Renderer.init()
  Renderer.x_translation = love.graphics:getWidth() / 2
  Renderer.y_translation = love.graphics:getHeight() / 2
  
  Renderer.title_font = love.graphics.newFont("assets/fonts/opsb.ttf", 70)
  Renderer.status_font = love.graphics.newFont("assets/fonts/opsb.ttf", 50)
  Renderer.hud_font = love.graphics.newFont("assets/fonts/opsb.ttf", 30)
end

function Renderer.preDraw()
  love.graphics.translate(Renderer.x_translation, Renderer.y_translation)
end

function Renderer.drawObject(object)
  if object.sprite then
    SpriteHandler.drawSprite(object.sprite, object.x, object.y)
  elseif object.current then
    for i = #object.current, 1, -1 do
      local obj = object.current[i]
      SpriteHandler.drawSprite(obj.sprite, obj.x, obj.y)
    end
  else
    for k, sub in pairs(object) do
      SpriteHandler.drawSprite(sub.sprite, sub.x, sub.y)
    end
  end
end

function Renderer.drawHUDMessage(message, x, y, font)
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(0, 0, 0)
  
  love.graphics.setFont(font or Renderer.hud_font)
  love.graphics.print(message, x - Renderer.x_translation, y - Renderer.y_translation)
  
  love.graphics.setColor(r, g, b, a)
end

function Renderer.drawStatusMessage(message, y)
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(0, 0, 0)
  
  love.graphics.setFont(Renderer.status_font)
  
  local y = y or 0
  love.graphics.printf(message, -Renderer.x_translation, y - (Renderer.status_font:getHeight() / 2), love.graphics:getWidth(), "center") 
  
  love.graphics.setColor(r, g, b, a)
end

function Renderer.drawAlignedMessage(message, y, alignment, font)
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(0, 0, 0)
  
  love.graphics.setFont(font)
  love.graphics.printf(message, -Renderer.x_translation, y - (font:getHeight() / 2), love.graphics:getWidth(), alignment)
  
  love.graphics.setColor(r, g, b, a)
end

Renderer.init()

return Renderer