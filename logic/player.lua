local Player = {}

function Player.load()
  Player.x, Player.y = love.mouse.getPosition()
  Player.x = Player.x - Renderer.x_translation
  Player.y = Player.y - Renderer.y_translation
  
  Player.idle_sprite = SpriteHandler.loadSprite("player/idle.tga", 1, 0.75)
  Player.hit_sprite = SpriteHandler.loadSprite("player/hit.tga", 1, 0.8)
  Player.death_sprite = SpriteHandler.loadLargeSprite("player/death.tga", 1, 2, 54, 38, 1.5)
  
  Player.sentry_sprite = SpriteHandler.loadSprite("player/sentry.tga", 1, 1)
  Player.sentry = false
  
  Player.sprite = Player.idle_sprite
  Player.old_sprite = Player.sprite
  
  Player.score = 0
  
  Player.max_health = 100
  Player.health = Player.max_health
  
  Player.max_mana = 100
  Player.mana = Player.max_mana
  Player.mana_use_modifier = 1
  
  Player.world_speed_modifier = 1
  
  Player.state = State.normal
  
  Player.bullets = {}
  Player.shadow = {}
  
  Player.health_bar = StatBar.createBar(Player.health, 10, false)
  Player.health_bar:setDimensions(10, 10, love.graphics.getWidth() / 3, love.graphics.getHeight() / 80)
  Player.health_bar:setColor(255, 0, 0, 101, 0, 0)
  
  Player.mana_bar = StatBar.createBar(Player.mana, Player.health_bar.height + 23, true)
  Player.mana_bar:setDimensions(10, Player.health_bar.height + 23, love.graphics.getWidth() / 3.75, love.graphics.getHeight() / 80)
  Player.mana_bar:setColor(0, 0, 255, 0, 0, 101)
end

function Player.update(dt)  
  Player.health_bar:update(Player.health, dt)
  Player.mana_bar:update(Player.mana, dt)
  
  if Player.mana + (Player.max_mana / 600) < Player.max_mana then
    Player.mana = Player.mana + (Player.max_mana / 600)
  elseif Player.mana > Player.max_mana * (5 / 6) then
    Player.mana = Player.max_mana
  end
  
  if Player.state == State.life_lost then
    LifeLost.update(dt)
  end
  
  if Player.state ~= State.destroyed then
    CrossHair.active = Player.sentry
    
    if not Player.sentry then
      Player.x, Player.y = love.mouse.getPosition()
 
      Player.x = Player.x - Renderer.x_translation
      Player.y = Player.y - Renderer.y_translation
    else
      Player.sprite = Player.sentry_sprite
    end
  end
  
  Player.sprite:update(dt)
  
  for k, bullet in pairs(Player.bullets) do    
    if Bullet.isOnScreen(bullet) then
      if bullet.ai then
        bullet:ai(dt)
      end
    
      bullet.sprite:update(dt)
    else
      table.remove(Player.bullets, k)
    end
  end
  
  for k, shadow in pairs(Player.shadow) do
    if shadow.ai then
      shadow:ai(dt)
    end
    
    shadow.sprite:update(dt)
  end

  
  if #Player.shadow == 0 then
    Player.createShadow()
  end
  
  AI.update(dt, Player)
end

function Player.shield()
  local num = 75
  
  if Player.mana < (num * Player.mana_use_modifier) then return end
  
  Player.mana = Player.mana - (Player.mana_use_modifier * num)
  
  local x, y = 3, 0
  local angle_change = (2 * math.pi) / num

  for i = 1, num do
    x, y = MathHelper.rotate(x, y, angle_change)
    
    local new_x = Player.x + x
    local new_y = Player.y + y
  
    local x_speed, y_speed = MathHelper.getUnitVector(new_x - Player.x, new_y - Player.y)
    
    x_speed = x_speed * 15
    y_speed = y_speed * 15
    
    new_x = new_x + (3 * x_speed)
    new_y = new_y + (3 * y_speed)

    Player.bullets[#Player.bullets + 1] = Bullet.createBullet(new_x, new_y, x_speed, y_speed, SpriteHandler.loadLargeSprite("projectile/shield.tga", 0.5, 1, 48, 24))
    Player.bullets[#Player.bullets].ai = AI.shield
    Player.bullets[#Player.bullets].max_time = 2.5
    Player.bullets[#Player.bullets].current_time = 0
    Player.bullets[#Player.bullets].last_x = Player.x
    Player.bullets[#Player.bullets].last_y = Player.y
  end
end

function Player.fireAtCrossHair()
  local num = 20
  
  if Player.mana < (num * Player.mana_use_modifier) then return end
  
  Player.mana = Player.mana - (Player.mana_use_modifier * num)

  for i = 1, num do
    local x, y = Player.x, Player.y 
    local x_speed, y_speed = MathHelper.getUnitVector(CrossHair.x - Player.x, CrossHair.y - Player.y)
    
    local bullet_x, bullet_y = x + (x_speed * i), y + (y_speed * i)
    x_speed, y_speed = x_speed * 0.1 * i, y_speed * 0.1 * i
    
    Player.bullets[#Player.bullets + 1] = Bullet.createBullet(bullet_x + x_speed, bullet_y + y_speed, x_speed * 250, y_speed * 250, SpriteHandler.loadLargeSprite("projectile/bullet.tga", 0.8, 1, 16, 26))
    
    Player.bullets[#Player.bullets].ai = AI.pointing
  end
end

function Player.dropMine()
  local num = 75
  
  if Player.mana < (num * Player.mana_use_modifier) then return end
  
  Player.mana = Player.mana - (Player.mana_use_modifier * num)
  
  for i = 1, num do
    local xs = ((math.random() * 2) - 1) * 200
    local ys = ((math.random() * 2) - 1) * 200
    
    Player.bullets[#Player.bullets + 1] = Bullet.createBullet(Player.x, Player.y, xs, ys, SpriteHandler.loadSprite("projectile/mine.tga", 1, 1))
    Player.bullets[#Player.bullets].ai = nil
    Player.bullets[#Player.bullets].sprite.rotating = true
  end
end

function Player.createShadow()
  local num = 10
  
  for i = 1, num do
    Player.shadow[#Player.shadow + 1] = Bullet.createBullet(Player.x, Player.y, 0, 0, SpriteHandler.loadSprite("player/shadow.tga", 1, 0.75))
    Player.shadow[#Player.shadow].ai = AI.shadowPlayer
    Player.shadow[#Player.shadow].offset = i * 2
    Player.shadow[#Player.shadow].track_speed = 350 + i
    Player.shadow[#Player.shadow].sprite.alpha = (255 / (num + 1)) * i
  end
end

Player.load()

return Player