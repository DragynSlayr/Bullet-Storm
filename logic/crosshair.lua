local CrossHair = {}

function CrossHair.init()
  CrossHair.sprite = SpriteHandler.loadSprite("misc/crosshair.tga", 0.8, 1)
  CrossHair.sprite.rotating = true
  CrossHair.active = false
  CrossHair.x, CrossHair.y = love.mouse.getPosition()
end

function CrossHair.update(dt)
  if CrossHair.active then
    CrossHair.sprite:update(dt)
    
    CrossHair.x, CrossHair.y = love.mouse.getPosition()
    
    CrossHair.x = CrossHair.x - Renderer.x_translation
    CrossHair.y = CrossHair.y - Renderer.y_translation
  end
end

function CrossHair.draw()
  if CrossHair.active then
    Renderer.drawObject(CrossHair)
  end
end

CrossHair.init()

return CrossHair