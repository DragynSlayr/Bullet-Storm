local AI = {}

function AI:tracking(dt)
  self.sprite.rotation = MathHelper.getAngleBetween(Player, self)
  
  self.elapsed = self.elapsed + dt
  
  if self.elapsed <= self.tracking_time then
    local unit_x, unit_y = MathHelper.getUnitVector(Player.x - self.x, Player.y - self.y)
    
    self.x_speed = unit_x * self.track_speed
    self.y_speed = unit_y * self.track_speed
  else
    self.ai = AI.pointing
  end
end

function AI:wanderer(dt)
  self.x_speed = self.next_x - self.x
  self.y_speed = self.next_y - self.y
  
  if MathHelper.getLength(self.x_speed, self.y_speed) * dt < 1 then
    self.next_x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
    self.next_y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation
  end
end

function AI:spikeShield(dt)
  self.sprite.rotation = MathHelper.getAngleBetween(self, self.shielding)
  
  if self.phase == 1 then
    if self.last_x and self.last_y then
      self.x_speed = (self.shielding.x - self.last_x) / dt
      self.y_speed = (self.shielding.y - self.last_y) / dt
    end
    
    self.last_x = self.shielding.x
    self.last_y = self.shielding.y
  
    self.elapsed = self.elapsed + dt
  
    if self.elapsed > self.cooldown then 
      self.x_dist = self.x - self.shielding.x
      self.y_dist = self.y - self.shielding.y
      
      self.elapsed = 0
      self.phase = 2
    end
  elseif self.phase == 2 then
    self.x_speed = 0
    self.y_speed = 0
    
    self.elapsed = self.elapsed + dt
  
    if self.elapsed > self.cooldown then
      self.elapsed = 0
      self.phase = 3
    end
  elseif self.phase == 3 then
    self.x_speed = ((self.shielding.x + self.x_dist) - self.x)
    self.y_speed = ((self.shielding.y + self.y_dist) - self.y)
    
    if MathHelper.getDistanceBetween(self, self.shielding) <= 60 then
      self.phase = 1
      
      self.last_x = self.x + self.x_dist
      self.last_y = self.y + self.y_dist
    end
  end
end

function AI:defensiveBoss(dt)
  self.x_speed = self.next_x - self.x
  self.y_speed = self.next_y - self.y
  
  if MathHelper.getLength(self.x_speed, self.y_speed) * dt < 3 then
    self.next_x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
    self.next_y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation
  end
  
  local dist = MathHelper.getDistanceBetween(Player, self)
  
  if dist < love.graphics.getWidth() / 4 then
    self.sprite.rotation = self.sprite.rotation - (0.1 * math.pi)
    
    self.elapsed = self.elapsed + dt
    
    if self.elapsed > self.cooldown then
      self.elapsed = 0
      
      local x, y = 56, 0
      local num = math.ceil((150 - ((BossHandler.health / BossHandler.max_health) * 100)) / 5)
      
      local proj = {}
      proj.current = {}
    
      for i = 1, num do
        x, y = MathHelper.rotate(x, y, (2 * math.pi) / num)
        local new_x, new_y = self.x + x, self.y + y
        
        proj.current[i] = Bullet.createBullet(new_x, new_y, x, y, SpriteHandler.loadSprite("projectile/dart.tga", 1.5, 1))
        proj.current[i].ai = AI.pointing
        proj.current[i].damage = Player.max_health / 10
      end
      
      BossHandler.add(proj)
    end
  else
    self.elapsed = 0
    self.sprite.rotation = self.sprite.rotation + (0.025 * math.pi)
  end
end

function AI:daggerBoss(dt)
  self.elapsed = self.elapsed + dt
  
  if self.phase == 1 then
    self.x_speed = self.next_x - self.x
    self.y_speed = self.next_y - self.y
    
    if MathHelper.getLength(self.x_speed, self.y_speed) * dt < 3 then
      self.next_x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
      self.next_y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation
    end
    
    if self.clockwise then
      self.sprite.rotation = self.sprite.rotation + (2 * math.pi * dt)
    else 
      self.sprite.rotation = self.sprite.rotation - (2 * math.pi * dt)
    end
    
    if self.elapsed > (self.cooldown * 3) then
      self.elapsed = 0
      self.phase = 2
    end
  elseif self.phase == 2 then
    self.sprite.rotation = MathHelper.getAngleBetween(self, Player) + (0.5 * math.pi)
    
    self.x_speed = 0
    self.y_speed = 0
    
    if self.elapsed > self.cooldown then
      self.elapsed = 0
      self.phase = 3
    end
  elseif self.phase == 3 then
    if self.elapsed <= (self.cooldown / 5) then
      self.sprite.rotation = MathHelper.getAngleBetween(self, Player) + (0.5 * math.pi)

      local unit_x, unit_y = MathHelper.getUnitVector(Player.x - self.x, Player.y - self.y)
      self.target_x = unit_x * 1961
      self.target_y = unit_y * 1961
    elseif self.elapsed > (self.cooldown / 5) and self.elapsed < self.cooldown then
      self.x_speed = self.target_x
      self.y_speed = self.target_y
      
      local copy = {["x"] = self.x + self.x_speed, ["y"] = self.y + self.y_speed}
      self.sprite.rotation = MathHelper.getAngleBetween(copy, self) + (1.5 * math.pi)
    elseif not Bullet.isOnScreen(self) then
      self.elapsed = 0
      self.phase = 1
    end
  end
end

function AI:swordBossCore(dt)
  self.elapsed = self.elapsed + dt
  
  if self.phase == 1 then
    self.x_speed = self.next_x - self.x
    self.y_speed = self.next_y - self.y
    
    if MathHelper.getLength(self.x_speed, self.y_speed) * dt < 3 then
      self.next_x = MathHelper.random(love.graphics.getWidth()) - Renderer.x_translation
      self.next_y = MathHelper.random(love.graphics.getHeight()) - Renderer.y_translation
    end
    
    self.sprite.rotation = self.sprite.rotation + (2 * math.pi * dt)
    
    if self.elapsed > (self.cooldown * 3) then
      self.elapsed = 0
      self.phase = 2
    end
  elseif self.phase == 2 then
    self.x_speed = 0
    self.y_speed = 0
    
    if self.elapsed < self.cooldown * 0.5 then
      self.sprite.rotation = MathHelper.getAngleBetween(self, Player)
    elseif self.elapsed > self.cooldown then
      self.elapsed = 0
      self.phase = 3
    end
  elseif self.phase == 3 then
    self.x_speed = 0
    self.y_speed = 0
    
    if self.elapsed > self.cooldown then
      self.elapsed = 0
      self.phase = 4
    end
  elseif self.phase == 4 then
    self.x_speed = 0
    self.y_speed = 0
    
    if self.elapsed > self.cooldown then
      self.elapsed = 0
      self.phase = 1
    end
  end
end

function AI:swordBoss(dt)
  if self.trigger.phase == 1 then
    self.sprite.rotation = MathHelper.getAngleBetween(self, self.trigger) + (math.pi * 1.5)
    
    self.x_speed = 0
    self.y_speed = 0
    
    self.rot_x, self.rot_y = MathHelper.rotate(self.x - self.last_x, self.y - self.last_y, math.pi * dt)
    
    self.x = self.trigger.x + self.rot_x
    self.y = self.trigger.y + self.rot_y
    
    self.attacked = false
  elseif self.trigger.phase == 2 then
    self.x_speed = self.x - self.trigger.x
    self.y_speed = self.y - self.trigger.y
  elseif self.trigger.phase == 3 then
    if not self.attacked then
      self.attacked = true
      
      local unit_x, unit_y = MathHelper.getUnitVector(Player.x - self.x, Player.y - self.y)
      local rand_num = MathHelper.random(1961, 5200)
      
      self.x_speed = unit_x * rand_num
      self.y_speed = unit_y * rand_num
    end
    
    local copy = {["x"] = self.x + self.x_speed, ["y"] = self.y + self.y_speed}
    self.sprite.rotation = MathHelper.getAngleBetween(copy, self) + (0.5 * math.pi)
  else
    self.x_speed = ((self.trigger.x + self.start_x) - self.x) * 2
    self.y_speed = ((self.trigger.y + self.start_y) - self.y) * 2
    
    self.sprite.rotation = MathHelper.getAngleBetween(self, self.trigger) + (math.pi * 1.5)
    
    if MathHelper.getLength(self.x - self.trigger.x, self.y - self.trigger.y) < 250 then
      self.x_speed = 0
      self.y_speed = 0
      
      self.x = self.x_s + self.trigger.x
      self.y = self.y_s + self.trigger.y
    end
  end
  
  self.last_x = self.trigger.x
  self.last_y = self.trigger.y
end

function AI:hostileWanderer(dt)
  local unit_x, unit_y = MathHelper.getUnitVector(Player.x - self.x, Player.y - self.y)
  
  self.x_speed = unit_x * 165
  self.y_speed = unit_y * 165
  
  self.sprite.rotation = MathHelper.getAngleBetween(Player, self) + (math.pi / 2)
  
  self.elapsed = self.elapsed + dt
  
  if self.elapsed >= self.cooldown then
    self.elapsed = 0
    
    local proj = {}
    proj.current = {}
    
    for i = 1, 3 do
      proj.current[i] = Bullet.createBullet(self.x, self.y, Player.x - self.x, Player.y - self.y, SpriteHandler.loadSprite("projectile/wormhole.tga", 1, 1))
      proj.current[i].damage = Player.max_health / 10
      
      proj.current[i].ai = AI.stoppable
      
      proj.current[i].distance_travelled = 0
      proj.current[i].max_distance = love.graphics.getWidth() / 4
    end
    
    BossHandler.add(proj)
  end
end

function AI:stoppable(dt)
  self.sprite.rotation = self.sprite.rotation + (6 * dt)
  
  if self.distance_travelled > self.max_distance then
    self.x_speed = 0
    self.y_speed = 0
  end
  
  if not self.start then
    self.start = {["x"] = self.x, ["y"] = self.y}
  end
  
  self.distance_travelled = MathHelper.getDistanceBetween(self, self.start)
end

function AI:follower(dt)
  local unit_x, unit_y = MathHelper.getUnitVector(self.following.x - self.x, self.following.y - self.y)
  
  self.x_speed = unit_x * 160
  self.y_speed = unit_y * 160
  
  if self.is_tail then 
    local copy = {["x"] = self.x + self.x_speed, ["y"] = self.y + self.y_speed}
    self.sprite.rotation = MathHelper.getAngleBetween(copy, self) + (1.5 * math.pi)
  else
    self.sprite.rotation = MathHelper.getAngleBetween(Player, self) + (1.5 * math.pi)
  end
end

function AI:mirror(dt)
  self.x_speed = -self.mirror.x_speed
  self.y_speed = -self.mirror.y_speed
  
  local copy = {["x"] = self.x + self.x_speed, ["y"] = self.y + self.y_speed}
  self.sprite.rotation = MathHelper.getAngleBetween(copy, self) + (math.pi / 2)
end

function AI:pointing(dt)
  local copy = {["x"] = self.x + self.x_speed, ["y"] = self.y + self.y_speed}
  self.sprite.rotation = MathHelper.getAngleBetween(copy, self) + (self.theta or 0)
end

function AI:facePlayer(dt)
  self.sprite.rotation = MathHelper.getAngleBetween(Player, self)
end

function AI:shieldBoss(dt)
  if self.trigger.phase == 1 then
    self.sprite.rotation = MathHelper.getAngleBetween(Player, self)
    
    self.x_speed = 0
    self.y_speed = 0
    
    self.rot_x, self.rot_y = MathHelper.rotate(self.x - self.last_x, self.y - self.last_y, math.pi * dt)
    
    self.x = Player.x + self.rot_x
    self.y = Player.y + self.rot_y
  elseif self.trigger.phase == 2 then
    self.x_speed = 0
    self.y_speed = 0
  elseif self.trigger.phase == 3 then
    self.x_speed = ((Player.x + self.start_x) - self.x) * 3
    self.y_speed = ((Player.y + self.start_y) - self.y) * 3
    
    self.sprite.rotation = MathHelper.getAngleBetween(Player, self)
  else
    self.sprite.rotation = MathHelper.getAngleBetween(Player, self)
    
    self.x_speed = 0
    self.y_speed = 0
    
    self.x = Player.x + self.start_x
    self.y = Player.y + self.start_y
  end
  
  self.last_x = Player.x
  self.last_y = Player.y
end

function AI:shield(dt)
  if self.current_time == 0 then
    self.sprite.rotation = MathHelper.getAngleBetween(Player, self) + math.pi
  end

  self.current_time = self.current_time + dt
  
  if self.current_time <= self.max_time then
    self.x_speed = (Player.x - self.last_x) / dt
    self.y_speed = (Player.y - self.last_y) / dt
    
    self.last_x = Player.x
    self.last_y = Player.y
  else
    if not self.speed_set then
      self.x_speed = (self.x - Player.x)
      self.y_speed = (self.y - Player.y)
      self.speed_set = true
    end
  end
end

function AI:shadowPlayer(dt)
  if  MathHelper.getDistanceBetween(Player, self) > (Player.sprite.scaled_width / 2) then
    self.x_speed = (Player.x - self.x) * self.offset
    self.y_speed = (Player.y - self.y) * self.offset
  else
    self.x_speed = 0
    self.y_speed = 0
    
    self.x = Player.x
    self.y = Player.y
  end
end

function AI.update(dt, obj, is_boss)
  if is_boss then
    for k, boss in pairs(obj.current) do
      AI.update(dt, boss)
    end
  else
    if obj.current then
      for k, bullet in pairs(obj.current) do
        bullet.x = bullet.x + (bullet.x_speed * dt * Player.world_speed_modifier)
        bullet.y = bullet.y + (bullet.y_speed * dt * Player.world_speed_modifier)
      end
    end
    if obj.bullets then
      for k, bullet in pairs(obj.bullets) do
        bullet.x = bullet.x + (bullet.x_speed * dt * Player.world_speed_modifier)
        bullet.y = bullet.y + (bullet.y_speed * dt * Player.world_speed_modifier)
      end
    end
    if obj.shadow then
      for k, bullet in pairs(obj.shadow) do
        bullet.x = bullet.x + (bullet.x_speed * dt * Player.world_speed_modifier)
        bullet.y = bullet.y + (bullet.y_speed * dt * Player.world_speed_modifier)
      end
    end
  end
end

return AI