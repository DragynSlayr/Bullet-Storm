SpriteHandler = require("logic.spriteHandler")
MusicHandler = require("logic.musicHandler")
Background = require("logic.background")
Driver = require("logic.driver")

--[[
+---------------------------------------+
| Remaps functions and sets up the game |
+---------------------------------------+
]]--
local function init()
  -- Register key events
  love.keypressed = Driver.keyPressed
  
  -- Register mouse events
  love.mousepressed = Driver.mousePressed

  -- Register window events
  love.focus = Driver.focus
  
  -- Register love events
  love.load = Driver.load
  love.update = Driver.update
  love.draw = Driver.draw
  
  -- Set love environment
  love.graphics.setBackgroundColor(255, 255, 255)
end

init()