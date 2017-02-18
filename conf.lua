function love.conf(t)
  t.console = true
  t.window.fullscreen = true
  t.window.title = "Bullet Storm"
  t.window.width = 1600
  t.window.height = 900
  t.window.msaa = 8
  
  t.modules.joystick = false
  t.modules.physics = false
  t.modules.touch = false
  t.modules.video = false
  t.modules.thread = false 
end
