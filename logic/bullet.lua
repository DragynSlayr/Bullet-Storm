local Bullet = {}

function Bullet.createBullet(x, y, x_speed, y_speed, sprite)
  local bullet = {}
  
  bullet.x = x
  bullet.y = y
  
  bullet.x_speed = x_speed
  bullet.y_speed = y_speed
  
  bullet.sprite = sprite
  
  return bullet
end

function Bullet.isOnScreen(bullet)
  local max_x = love.graphics:getWidth() / 2 + 20
  local min_x = -max_x
  
  local max_y = love.graphics:getHeight() / 2 + 20
  local min_y = -max_y
  
  local x = bullet.x + (bullet.sprite.width / 2)
  local y = bullet.y + (bullet.sprite.height / 2)
  
  local x_valid = (x >= min_x) and (x <= max_x)
  local y_valid = (y >= min_y) and (y <= max_y)
  
  return x_valid and y_valid
end

return Bullet