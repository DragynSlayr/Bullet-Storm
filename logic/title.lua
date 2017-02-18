local Title = {}

function Title.create(text, min, max, speed)
  local title = {}
  title.text = {}
  
  title.min = min
  title.max = max
  
  local start_x = Renderer.x_translation - (Renderer.title_font:getWidth(text) / 2)
  
  local count = 1
  for i in string.gmatch(text, ".") do
    title.text[count] = {}
    
    title.text[count].letter = i
    
    title.text[count].x = start_x
    title.text[count].y = min + (count * ((max - min) / #text))
    
    title.text[count].speed = speed
    title.text[count].going_up = true
      
    start_x = title.text[count].x + Renderer.title_font:getWidth(i)
    count = count + 1
  end
  
  function title:update(dt)
    for i = 1, #self.text do
      local letter = self.text[i]
      if letter.going_up then
        letter.y = letter.y + (dt * letter.speed)
      else
        letter.y = letter.y - (dt * letter.speed)
      end
      
      if letter.y >= self.max then
        letter.going_up = false
      elseif letter.y <= self.min then
        letter.going_up = true
      end
    end
  end
  
  function title:draw()
    for i = 1, #self.text do
      local letter = self.text[i]
      Renderer.drawHUDMessage(letter.letter, letter.x, letter.y, Renderer.title_font)
    end
  end
  
  return title
end

return Title