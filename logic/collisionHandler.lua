local CollisionHandler = {}

function CollisionHandler.checkCollision(a, b)
  local collision_width = ((a.sprite.scaled_width + a.sprite.scaled_height) / 4) + ((b.sprite.scaled_width + b.sprite.scaled_height) / 4)
  
  return MathHelper.getDistanceBetween(a, b) < collision_width
end

return CollisionHandler