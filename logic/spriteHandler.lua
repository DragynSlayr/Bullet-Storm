local SpriteHandler = {}

function SpriteHandler.loadSprite(name, scale, delay)
  local Sprite = {}
  
  Sprite.image = love.graphics.newImage("assets/sprites/" .. name)
  
  Sprite.frames = Sprite.image:getWidth() / Sprite.image:getHeight()
  
  Sprite.height = Sprite.image:getHeight()
  Sprite.width = Sprite.image:getWidth() / Sprite.frames
  
  Sprite.scale = scale
  Sprite.scaled_height = Sprite.height * Sprite.scale
  Sprite.scaled_width = Sprite.width * Sprite.scale
  
  Sprite.sprites = {}
  
  for i = 0, Sprite.frames - 1 do
    Sprite.sprites[i + 1] = love.graphics.newQuad(i * Sprite.width, 0, Sprite.width, Sprite.height, Sprite.image:getDimensions())
  end
  
  Sprite.time = 0
  Sprite.max_time = delay / Sprite.frames
  Sprite.current_frame = 1
  
  Sprite.rotation = 0
  
  Sprite.update = SpriteHandler.update
  
  return Sprite
end

function SpriteHandler.loadLargeSprite(name, scale, delay, width, height, y_scale)
  local Sprite = {}
  
  Sprite.image = love.graphics.newImage("assets/sprites/" .. name)
  
  Sprite.frames = Sprite.image:getWidth() / width
  
  Sprite.height = height
  Sprite.width = width
  
  Sprite.scale = scale
  Sprite.scaled_height = Sprite.height * (y_scale or Sprite.scale)
  Sprite.scaled_width = Sprite.width * Sprite.scale
  
  Sprite.y_scale = y_scale
  
  Sprite.sprites = {}
  
  for i = 0, Sprite.frames - 1 do
    Sprite.sprites[i + 1] = love.graphics.newQuad(i * Sprite.width, 0, Sprite.width, Sprite.height, Sprite.image:getDimensions())
  end
  
  Sprite.time = 0
  Sprite.max_time = delay / Sprite.frames
  Sprite.current_frame = 1
  
  Sprite.rotation = 0
  
  Sprite.update = SpriteHandler.update
  
  return Sprite
end

function SpriteHandler:update(dt)
  if self.rotating then
    self.rotation = self.rotation + (math.pi * dt * Player.world_speed_modifier)
  end
  
  self.time = self.time + (dt * Player.world_speed_modifier)
  
  if self.time >= self.max_time then
    self.time = 0
    if self.current_frame == self.frames then
      self.current_frame = 1
    else
      self.current_frame = self.current_frame + 1
    end
  end
end

function SpriteHandler.drawSprite(sprite, x, y)
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(r, g, b, sprite.alpha or a)
  
  love.graphics.draw(sprite.image, sprite.sprites[sprite.current_frame], x, y, sprite.rotation, sprite.scale, sprite.y_scale or sprite.scale, sprite.width / 2, sprite.height / 2)
  
  love.graphics.setColor(r, g, b, a)
end

return SpriteHandler