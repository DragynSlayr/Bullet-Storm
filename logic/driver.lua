local Driver = {}

State = require("logic.state")
MathHelper = require("logic.mathHelper")
Renderer = require("logic.renderer")
Bullet = require("logic.bullet")
CollisionHandler = require("logic.collisionHandler")

StatBar = require("logic.statBar")

LevelHandler = require("levels.levelHandler")
BossHandler = require("bosses.bossHandler")

Player = require("logic.player")

LifeLost = require("logic.lifeLost")

Countdown = require("logic.countdown")

local Selector = require("logic.selector")
Selection = Selector.create()

local Title = require("logic.title")
TopTitle = Title.create("Bullet", love.graphics.getHeight() * 0.0, love.graphics.getHeight() * 0.3, love.graphics.getHeight() / 7.5)
BottomTitle = Title.create("Storm", love.graphics.getHeight() * 0.6, love.graphics.getHeight() * 0.9, love.graphics.getHeight() / 7)
GameOverTitle = Title.create("Game Over", love.graphics.getHeight() * 0.0, love.graphics.getHeight() * 0.3, love.graphics.getHeight() / 7.5)

Score = require("logic.score")

CrossHair = require("logic.crosshair")

local Menu = require("logic.menu")
local MainMenu = Menu.create(
  {
    "Play",
    "Options",
    "Exit"
  }, 
  {
    function() 
      State.current = State.countdown 
    end, 
    
    function() 
      State.current = State.options_menu 
    end, 
    
    function() 
      love.event.quit()
    end
  }
)
local EndMenu = Menu.create(
  {
    "Restart",
    "Exit"
  }, 
  {
    function() 
      Driver.init()
      State.current = State.countdown
      LevelHandler.nextLevel()
    end,
    
    function()
      Score.save()
      love.event.quit()
    end
  }
)

function Driver.init()
  LevelHandler.load()
  BossHandler.load()
  
  Player.load()
  
  Driver.load()
  
  Countdown.init()
end

function Driver.keyPressed(key)
  if key == "escape" then
    Score.save()
    love.event.quit()
  elseif key == "space" then
    if State.is_paused then
      Driver.unpause()
    else
      Driver.pause()
    end
    
    State.is_paused = not State.is_paused
  end
end

function Driver.pause()
  State.last = State.current
  State.current = State.paused
end

function Driver.unpause()
  State.current = State.last
end

function Driver.mousePressed(x, y, button)
  if State.current == State.main_menu then
    MainMenu.checkClick(x, y, button)
  elseif State.current == State.running then
    if Player.state == State.normal then
      if button == 1 then
        if Player.sentry then
          Player.fireAtCrossHair()
        else
          Player.dropMine()
        end
      elseif button == 2 then
        if Player.sentry then
          Player.sentry = false
          Player.sprite = Player.old_sprite
        else
          Player.sentry = true
          Player.old_sprite = Player.idle_sprite
        end
      elseif button == 3 then
        Player.shield()
      end
    elseif Player.state == State.destroyed then
      EndMenu.checkClick(x, y, button)
    end
  end
end

function Driver.focus(focus)
  if not focus then
    Driver.pause()
  end
  
  State.is_paused = true
end

function Driver.load()
  MusicHandler.play()
  Driver.red = 50
end

function Driver.update(dt)
  MusicHandler.update(dt)
  Background.update(dt)
  
  if State.current == State.main_menu then
    love.mouse.setVisible(true)
    MainMenu.update(dt)
    
    TopTitle:update(dt)
    BottomTitle:update(dt)
  elseif State.current == State.countdown then
    Countdown.update(dt)
    MusicHandler.fadeTo(MusicHandler.enemy, 50, 2.5, 1, 5, 3, 2)
    Background.fadeTo(Background.bamboo, 100, 2.5, 1, 39, 3, 1.5)
  elseif State.current == State.running then
    Player.update(dt)
    Score.update(Player.score, dt)
    
    if Player.state ~= State.destroyed then
      CrossHair.update(dt)
      
      LevelHandler.is_boss = ((LevelHandler.beat + 1) % LevelHandler.boss_start) == 0
      
      if LevelHandler.is_boss then
        if BossHandler.alive then
          if BossHandler.health <= 0 then
            BossHandler.alive = false
            BossHandler.beat = BossHandler.beat + 1
            
            LevelHandler.beat = LevelHandler.beat + 1
            LevelHandler.nextLevel()
            
            Player.score = Player.score + 10--((BossHandler.health_bar.max + Player.health) * 25)
            
            Player.health = Player.max_health
            Player.mana = Player.max_mana
            
            Player.mana_bar.max = Player.mana
            
            if Player.mana_use_modifier * 0.63 > 0.10 then
              Player.mana_use_modifier = Player.mana_use_modifier * 0.63
            end
          end
        else
          BossHandler.nextBoss()
        end
        
        BossHandler.update(dt)
      else
        if table.getn(LevelHandler.current) == 0 then
          LevelHandler.beat = LevelHandler.beat + 1
          
          is_boss = ((LevelHandler.beat + 1) % LevelHandler.boss_start) == 0
          
          if is_boss then
            BossHandler.nextBoss()
          else
            LevelHandler.nextLevel()
          end
        end
        
        LevelHandler.update(dt)
      end
    else
      if Driver.red + (5 * dt) < 255 then
        Driver.red = Driver.red + (75 * dt)
      else
        Driver.red = 255
      end
      
      EndMenu.update(dt)
      GameOverTitle:update(dt)
    end
  end
end

function Driver.draw()
  Renderer.preDraw()
  
  Background.draw()
  
  if State.current == State.main_menu then
    MainMenu.draw()
    
    TopTitle:draw()
    BottomTitle:draw()
  elseif State.current == State.countdown then
    Countdown.draw()
  elseif State.current == State.paused then
    love.graphics.setBackgroundColor(255, 255, 255)
    Renderer.drawStatusMessage("Paused")
  elseif State.current == State.running then
    if Player.state ~= State.destroyed then
      love.mouse.setVisible(false)
    end
    
    CrossHair.draw()
    
    Player.health_bar:draw()
    Player.mana_bar:draw()
    
    if LevelHandler.is_boss then
      if BossHandler.health_bar then
        BossHandler.health_bar:draw()
      end
      
      BossHandler.draw()
    else
      Renderer.drawObject(LevelHandler)
    end
    
    if #Player.bullets > 0 then
      Renderer.drawObject(Player.bullets)
    end
    
    Renderer.drawObject(Player.shadow)
    Renderer.drawObject(Player)
    
    Renderer.drawAlignedMessage("High Score: " .. math.floor(Score.highscore) .. "\r", (-love.graphics.getHeight() / 2) + 15, "right", Renderer.hud_font)
    Renderer.drawAlignedMessage("Score: " .. Score.score .. "\r", (-love.graphics.getHeight() / 2) + (Renderer.hud_font:getHeight() + 10), "right", Renderer.hud_font)
    
    if Player.state ~= State.destroyed then 
      local r = (Player.mana / Player.max_mana) * 255
      local g = 255
      local b = (Player.health / Player.max_health) * 255
      
      if LevelHandler.is_boss then
        g = (BossHandler.health / BossHandler.max_health) * 255
      else
        g = (#LevelHandler.current / LevelHandler.total) * 255
      end
      
      love.graphics.setBackgroundColor(math.ceil(r), math.ceil(g), math.ceil(b))
    else
      love.graphics.setBackgroundColor(Driver.red or 1, 0, 0)
      Renderer.drawObject(Player)
      
      EndMenu.draw()
      GameOverTitle:draw()
    end
  end
end

Driver.load()

return Driver