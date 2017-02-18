local Boss = {}

function Boss.load()
  local boss = {}
  boss.current = {}
  
  local num = 361
  
  local x, y = MathHelper.getRandomUnitStart()

  local angle_change = (2 * math.pi) / num
  
  for i = 1, num do
    x, y = MathHelper.rotate(x, y, angle_change)
    
    local x_speed, y_speed = MathHelper.getUnitVector(Player.x - x, Player.y - y)
      
    local rand_num = math.random(125, 150)
      
    x_speed = x_speed * rand_num
    y_speed = y_speed * rand_num
    
    if i == 1 then
      boss.current[i] = Bullet.createBullet(x, y, x_speed, y_speed, SpriteHandler.loadLargeSprite("boss/serpent/head.tga", 1, 0.1, 84, 56))
      boss.current[i].ai = AI.hostileWanderer
      boss.current[i].hit_point = true
    else
      if i % 2 == 0 and i > 5 then
        boss.current[i] = Bullet.createBullet(x, y, x_speed, y_speed, SpriteHandler.loadLargeSprite("boss/serpent/tail.tga", 1, 1, 96, 48))
        boss.current[i].is_tail = true
      else
        boss.current[i] = Bullet.createBullet(x, y, x_speed, y_speed, SpriteHandler.loadSprite("boss/serpent/body.tga", 1, 1))
      end
      
      boss.current[i].ai = AI.follower
      boss.current[i].following = boss.current[i - 1]
      
      if i == num then
        boss.current[i].hit_point = true
      end
    end
    
    boss.current[i].indestructible = true
    boss.current[i].damage = Player.max_health / 10
  end

  boss.current[1].elapsed = 0
  boss.current[1].cooldown = 3
  
  boss.max_health = 100
  boss.health = boss.max_health
  
  boss.alive = true
  
  BossHandler.add(boss)
end

return Boss