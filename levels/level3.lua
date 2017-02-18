local Level = {}

function Level.load()
  local num = 20
  
  for i = 1, num do
    local x = math.random(-love.graphics:getWidth() / 3, love.graphics:getWidth() / 3)
    local y = math.random(-love.graphics:getHeight() / 3, love.graphics:getHeight() / 3)
    
    local proj = Bullet.createBullet(x, y, 0, 0, SpriteHandler.loadSprite("enemy/tracker.tga", 1, 0.5))
    
    proj.ai = AI.tracking
    proj.elapsed = 0
    proj.tracking_time = i
    proj.track_speed = 200 + (i * 12.5)
    proj.damage = Player.max_health / 10
    
    LevelHandler.add(proj)
  end
  
  Level.bullet_point = 360 / num
end

return Level