local Boss = {}

function Boss.load()
  local boss = {}
  boss.current = {}
  
  local num_swords, num_shields = 8, 6
  
  local x, y = 48, 0
  
  for i = 1, num_swords + 1 do
    
    if i == 1 then
      boss.current[i] = Bullet.createBullet(0, 0, 0, 0, SpriteHandler.loadSprite("boss/protector/core.tga", 1, 1))
      
      boss.current[i].ai = AI.swordBossCore
      boss.current[i].sprite.rotating = true
      
      boss.current[i].next_x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
      boss.current[i].next_y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation
      
      boss.current[i].elapsed = 0
      boss.current[i].phase = 1 
      boss.current[i].cooldown = 2
      
      boss.current[i].hit_point = true
    else
      x, y = MathHelper.rotate(x, y, (2 * math.pi) / num_swords)
      
      boss.current[i] = Bullet.createBullet(x, y, x_speed, y_speed, SpriteHandler.loadLargeSprite("boss/protector/sword.tga", 1.2, 1, 64, 17))
      
      boss.current[i].ai = AI.swordBoss
      boss.current[i].trigger = boss.current[1]
      
      boss.current[i].elapsed = 0
      boss.current[i].phase = 1 
      boss.current[i].cooldown = 2
      
      boss.current[i].last_x = boss.current[1].x
      boss.current[i].last_y = boss.current[1].y
      
      boss.current[i].start_x = boss.current[i].x - boss.current[1].x
      boss.current[i].start_y = boss.current[i].y - boss.current[1].y
      
      boss.current[i].x_s = x
      boss.current[i].y_s = y
    end
    
    boss.current[i].indestructible = true
    boss.current[i].damage = Player.max_health / 10
  end

  x, y = 21, 0

  for i = num_swords + 2, num_swords + num_shields + 1 do
    x, y = MathHelper.rotate(x, y, (2 * math.pi) / num_shields)
    
    local new_x = Player.x + x
    local new_y = Player.y + y
  
    local x_speed, y_speed = MathHelper.getUnitVector(new_x - Player.x, new_y - Player.y)
    
    x_speed = x_speed * 15
    y_speed = y_speed * 15
    
    new_x = new_x + (3 * x_speed)
    new_y = new_y + (3 * y_speed)

    boss.current[i] = Bullet.createBullet(new_x, new_y, x_speed, y_speed, SpriteHandler.loadLargeSprite("boss/protector/shield.tga", 1.2, 1, 27, 26))
    boss.current[i].ai = AI.shieldBoss
    
    boss.current[i].last_x = Player.x
    boss.current[i].last_y = Player.y
    
    boss.current[i].start_x = boss.current[i].x - Player.x
    boss.current[i].start_y = boss.current[i].y - Player.y
    
    boss.current[i].indestructible = true
    boss.current[i].passive = true
    
    boss.current[i].trigger = boss.current[1]
  end
  
  boss.max_health = 50
  boss.health = boss.max_health
  
  boss.alive = true
  
  BossHandler.add(boss)
end

return Boss