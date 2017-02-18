local Countdown = {}

function Countdown.init()
  Countdown.max_time = 3
  Countdown.current_time = Countdown.max_time
  
  Countdown.message = "Start"
  
  Countdown.font = love.graphics.newFont("assets/fonts/opsb.ttf", 75)
end

function Countdown.update(dt)
  Countdown.current_time = Countdown.current_time - dt
  local time = math.ceil(Countdown.current_time)
  
  if time == 0 then
    Countdown.text = Countdown.message
  else
    Countdown.text = time
  end
  
  if Countdown.current_time <= -1 then
    State.current = State.running
  end
end

function Countdown.draw()
  local f = love.graphics.getFont()
  local r, g, b, a = love.graphics.getColor()
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(Countdown.font)
  
  love.graphics.printf(Countdown.text or "", -Renderer.x_translation, -Countdown.font:getHeight(), love.graphics.getWidth(), "center")
  
  love.graphics.setFont(f)
  love.graphics.setColor(r, g, b, a)
end

Countdown.init()

return Countdown