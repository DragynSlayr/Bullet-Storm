local Boss = {}

function Boss.load()
  local boss = {}
  boss.current = {}

  local num = 23
  
  local x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
  local y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation
  
  local spike_x, spike_y = 56, 0
  
  for i = 1, num do 
    local x_speed, y_speed = MathHelper.getUnitVector(Player.x - x, Player.y - y)
      
    local rand_num = MathHelper.random(125, 150)
      
    x_speed = x_speed * rand_num
    y_speed = y_speed * rand_num
    
    if i == 1 then      
      boss.current[i] = Bullet.createBullet(x, y, x_speed, y_speed, SpriteHandler.loadSprite("boss/orb/orb.tga", 1.75, 1))
      boss.current[i].ai = AI.wanderer
      boss.current[i].hit_point = true
      boss.current[i].rotating = true
      
      boss.current[i].next_x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
      boss.current[i].next_y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation
    else
      spike_x, spike_y = MathHelper.rotate(spike_x, spike_y, (2 * math.pi) / (num - 1))
      
      local new_x, new_y = boss.current[1].x + spike_x, boss.current[1].y + spike_y
      
      boss.current[i] = Bullet.createBullet(new_x, new_y, x_speed, y_speed, SpriteHandler.loadSprite("projectile/shieldSpike.tga", 1, 78 / 60))
      boss.current[i].ai = AI.spikeShield
      boss.current[i].shielding = boss.current[1]
      boss.current[i].phase = 1
      
      boss.current[i].elapsed = 0
      boss.current[i].cooldown = 4
    end
    
    boss.current[i].indestructible = true
    boss.current[i].damage = Player.max_health / 10
  end
  
  boss.max_health = 50
  boss.health = boss.max_health
  
  boss.alive = true
  
  BossHandler.add(boss)
end

return Boss