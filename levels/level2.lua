local Level = {}

function Level.load()
  local num = 360
  
  local x, y = MathHelper.getRandomUnitStart()

  local angle_change = (2 * math.pi) / num
  
  local exit_num = num / 10
  
  for i = 1, num - exit_num do
    x, y = MathHelper.rotate(x, y, angle_change)
    
    local x_speed, y_speed = MathHelper.getUnitVector(Player.x - x, Player.y - y)
      
    local rand_num = math.random(125, 150)
      
    x_speed = x_speed * rand_num
    y_speed = y_speed * rand_num
  
    local proj = Bullet.createBullet(x, y, x_speed, y_speed, SpriteHandler.loadSprite("enemy/circle.tga", 1, 1.5))
    
    proj.ai = AI.pointing
    proj.theta = math.pi * (7 / 4)
    proj.damage = Player.max_health / 10
    
    LevelHandler.add(proj)
  end
  
  LevelHandler.bullet_point = 360 / (num - exit_num)
end

return Level