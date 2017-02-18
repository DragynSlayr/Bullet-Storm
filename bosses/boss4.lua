local Boss = {}

function Boss.load()
  local boss = {}
  boss.current = {}
  
  for i = 1, 12 do 
    local x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
    local y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation

    local x_speed, y_speed = MathHelper.getUnitVector(x - Player.x, y - Player.y)
    local rand_num = MathHelper.random(125, 150)
    x_speed = x_speed * rand_num
    y_speed = y_speed * rand_num

    boss.current[i] = Bullet.createBullet(x, y, x_speed, y_speed, SpriteHandler.loadLargeSprite("boss/daggers/dagger.tga", 1.5, 1, 60, 17))
    
    boss.current[i].ai = AI.daggerBoss
    boss.current[i].next_x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
    boss.current[i].next_y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation
    boss.current[i].elapsed = 0
    boss.current[i].cooldown = (i % 4) + 1
    boss.current[i].phase = 1
    boss.current[i].clockwise = (i % 2) == 0
    
    boss.current[i].hit_point = true
    boss.current[i].indestructible = true
    boss.current[i].damage = Player.max_health / 10
  end

  boss.max_health = 300
  boss.health = boss.max_health
  
  boss.alive = true
  
  BossHandler.add(boss)
end

return Boss