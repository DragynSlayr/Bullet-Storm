local Level = {}

function Level.load()
  local num = 50

  for i = 1, num do
    local x = math.random(-love.graphics:getWidth() / 3, love.graphics:getWidth() / 3)
    local y = math.random(-love.graphics:getHeight() / 3, love.graphics:getHeight() / 3)

    local x_speed = math.random(150, 200) * MathHelper.randomSign()
    local y_speed = math.random(150, 200) * MathHelper.randomSign()
    
    local proj = Bullet.createBullet(x, y, x_speed, y_speed, SpriteHandler.loadLargeSprite("enemy/bullet.tga", 0.75, 1, 20, 26))
    
    proj.ai = AI.pointing
    proj.damage = Player.max_health / 10
    
    LevelHandler.add(proj)
  end
  
  LevelHandler.bullet_point = 360 / num
end

return Level