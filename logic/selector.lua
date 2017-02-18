local Selector = {}

function Selector.create()
  local selector = {}
  
  selector.hover_sprite = SpriteHandler.loadLargeSprite("misc/hover.tga", 1, 1, 256, 64)
  selector.click_sprite = SpriteHandler.loadLargeSprite("misc/click.tga", 1, 1, 256, 64)
  
  selector.sprite = selector.hover_sprite
  
  selector.active = false
  selector.x = (love.graphics.getWidth() / 2) - Renderer.x_translation
  selector.y = 0
  
  function selector:update(dt)
    self.sprite:update(dt)
  end

  function selector:draw()
    if self.active then
      Renderer.drawObject(self)
    end
  end
  
  return selector
end

return Selector