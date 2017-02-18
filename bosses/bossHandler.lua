local BossHandler = {}

function BossHandler.load()
  BossHandler.num_bosses = 5
  BossHandler.current = {}
  BossHandler.bosses = {}
  
  for i = 1, BossHandler.num_bosses do 
    BossHandler.bosses[i] = require("bosses.boss" .. i)
  end
  
  BossHandler.beat = 0
  BossHandler.health = 0
  BossHandler.max_health = 0
end

function BossHandler.update(dt)
  if BossHandler.health_bar then
    BossHandler.health_bar:update(BossHandler.health, dt)
  end
  
  for idx, boss in pairs(BossHandler.current) do
    for k, v in pairs(boss.current) do
      if v.ai then
        v:ai(dt)
      end
      
      v.sprite:update(dt)
      
      if not Bullet.isOnScreen(v) and not v.indestructible then
        table.remove(BossHandler.current[idx], k)
      end
      
      for l, w in pairs(Player.bullets) do
        if CollisionHandler.checkCollision(w, v) then
          if not v.indestructible then
            table.remove(boss.current, k)
          end
          
          if v.hit_point then
            BossHandler.health = BossHandler.health - 1
          end
          
          table.remove(Player.bullets, l)
        end
      end
      
      if Player.state == State.normal then
        if CollisionHandler.checkCollision(Player, v) then
          if not v.indestructible then
            table.remove(boss.current, k)
          end
          
          if v.hit_point then
            BossHandler.health = BossHandler.health - 1
          end
          
          if not v.passive then
            Player.health = Player.health - v.damage
            Player.sentry = false
          
            if Player.health <= 0 then
              Player.state = State.destroyed
              Player.sprite = Player.death_sprite
              love.mouse.setVisible(true)
            else
              Player.state = State.life_lost
              LifeLost.init()
            end
          end
        end
      end
    end
  end
  
  AI.update(dt, BossHandler, true)
end

function BossHandler.nextBoss()
  BossHandler.current = {}
  
  for i = 1, BossHandler.beat + 1 do
    local next_boss = MathHelper.random(1, BossHandler.num_bosses)
    BossHandler.bosses[next_boss].load()
  end
  
  BossHandler.health_bar = StatBar.createBar(BossHandler.health, love.graphics.getHeight() * 0.975, false)
  BossHandler.health_bar:setDimensions(love.graphics.getWidth() * 0.025, nil, love.graphics.getWidth() * 0.95, nil)
  BossHandler.health_bar:setColor(0, 255, 255, 0, 101, 101)
end

function BossHandler.add(boss)
  BossHandler.current[#BossHandler.current + 1] = boss
  
  if boss.health then
    BossHandler.health = BossHandler.health + boss.health
    BossHandler.max_health = BossHandler.max_health + boss.health
    BossHandler.alive = true
  end
end

function BossHandler.draw()
  for k, boss in pairs(BossHandler.current) do
    Renderer.drawObject(boss)
  end
end

BossHandler.load()

return BossHandler