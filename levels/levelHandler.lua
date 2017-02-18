local LevelHandler = {}
AI = require("logic.ai")

function LevelHandler.load()
  LevelHandler.num_levels = 3
  LevelHandler.current = {}
  LevelHandler.levels = {}
  
  for i = 1, LevelHandler.num_levels do
    LevelHandler.levels[i] = require("levels.level" .. i)
  end
  
  LevelHandler.boss_start = -1 + 2
  LevelHandler.beat = 0
  
  LevelHandler.total = 0
  LevelHandler.bullet_point = 0
end

function LevelHandler.update(dt)
  if table.getn(LevelHandler.current) > 0 then
    for k, v in pairs(LevelHandler.current) do
      v.sprite:update(dt)
      
      if v.ai then
        v:ai(dt)
      end
      
      if not Bullet.isOnScreen(v) then
        table.remove(LevelHandler.current, k)
        Player.score = Player.score + (LevelHandler.bullet_point * Player.world_speed_modifier)
      end
      
      for l, w in pairs(Player.bullets) do
        if CollisionHandler.checkCollision(w, v) then
          table.remove(LevelHandler.current, k)
          table.remove(Player.bullets, l)
        end
      end
      
      if Player.state == State.normal then
        if CollisionHandler.checkCollision(Player, v) then
          table.remove(LevelHandler.current, k)
          
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
  
  AI.update(dt, LevelHandler)
end

function LevelHandler.nextLevel()
  LevelHandler.current = {}
  LevelHandler.total = 0

  local next_level = MathHelper.random(1, LevelHandler.num_levels)

  LevelHandler.levels[next_level].load()
end

function LevelHandler.add(projectile)
  LevelHandler.current[#LevelHandler.current + 1] = projectile
  LevelHandler.total = LevelHandler.total + 1
end

LevelHandler.load()

return LevelHandler