local Boss = {}

function Boss.load()
  local boss = {}
  boss.current = {}
  
  local x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
  local y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation

  local x_speed, y_speed = MathHelper.getUnitVector(x - Player.x, y - Player.y)
  local rand_num = MathHelper.random(125, 150)
  x_speed = x_speed * rand_num
  y_speed = y_speed * rand_num

  boss.current[1] = Bullet.createBullet(x, y, x_speed, y_speed, SpriteHandler.loadSprite("boss/eye/eye.tga", 1, 1))
  
  boss.current[1].ai = AI.defensiveBoss
  boss.current[1].next_x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
  boss.current[1].next_y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation
  boss.current[1].elapsed = 0
  boss.current[1].cooldown = 0.7
  
  boss.current[1].hit_point = true
  boss.current[1].indestructible = true
  boss.current[1].damage = Player.max_health / 10

  boss.max_health = 50
  boss.health = boss.max_health

  boss.alive = true
  
  BossHandler.add(boss)
end

return Boss