local StatBar = {}

function StatBar.createBar(stat, y, expandable)
  local bar = {}
  
  bar.max = stat
  bar.current_stat = bar.max
  bar.shadow = bar.max
  
  bar.expandable = expandable
  
  bar.width = love.graphics.getWidth() * 0.75
  bar.height = love.graphics.getHeight() / 80
  
  bar.y = y - (love.graphics.getHeight() / 2)
  bar.x = -(bar.width / 2)
  
  function bar:draw() 
    local r, g, b, a = love.graphics.getColor()
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x - 5, self.y - 5, self.width + 10, self.height + 10)
    
    love.graphics.setColor(self.sr, self.sg, self.sb)
    love.graphics.rectangle("fill", self.x, self.y, (self.width / self.max) * self.shadow, self.height)
    
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.rectangle("fill", self.x, self.y, (self.width / self.max) * self.current_stat, self.height)
    
    love.graphics.setColor(r, g, b, a)
  end

  function bar:update(stat, dt)
    if self.shadow > stat then
      local change = (self.current_stat - self.shadow - (self.max * 0.05))
      local mult = dt
      
      self.shadow = self.shadow + (change * mult)
    else
      self.shadow = stat
    end
    
    self.current_stat = stat
    
    if self.current_stat < 0 then
      self.current_stat = 0
    end
    
    if self.expandable then
      if self.last_max and self.last_max ~= self.max then
        local ratio = love.graphics.getWidth() / love.graphics.getHeight()
        self.width = math.min(self.width + ((self.max - self.last_max) * ratio), love.graphics.getWidth() / 3)
      end
    end
    
    self.last_max = self.max
  end
  
  function bar:setDimensions(x, y, width, height)
    if x then
      self.x = x - Renderer.x_translation
    end
    
    if y then
      self.y = y - Renderer.y_translation
    end
    
    if width then
      self.width = width
    end
    
    if height then
      self.height = height
    end
  end
  
  function bar:setColor(r, g, b, sr, sg, sb)
    self.r = r
    self.g = g
    self.b = b
    
    self.sr = sr
    self.sg = sg
    self.sb = sb
  end
  
  return bar
end

return StatBar