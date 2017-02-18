local Menu = {}

function Menu.create(text, actions)
  local menu = {}
  
  menu.selected = 0
  menu.options = {}
  
  for i = 1, #text do
    menu.options[i] = {}
    menu.options[i].text = text[i]
    
    menu.options[i].height = Renderer.status_font:getHeight()
    menu.options[i].width = Renderer.status_font:getWidth(menu.options[i].text)
    
    menu.options[i].x = -menu.options[i].width / 2
    menu.options[i].y = (75 * (i - 2)) - (Renderer.status_font:getHeight() / 2)
    
    menu.options[i].action = actions[i]
  end
  
  function menu.update(dt)
    local x, y = love.mouse.getPosition()
    local active, index = menu:onButton(x, y, true)
    
    if active == 1 then 
      Selection.sprite = Selection.click_sprite
      Selection.y = (menu.options[index].y - (menu.options[index].height / 2)) + Selection.sprite.height - 5
      Selection.active = true
    elseif active == 2 then
      Selection.sprite = Selection.hover_sprite
      Selection.y = (menu.options[index].y - (menu.options[index].height / 2)) + Selection.sprite.height - 5
      Selection.active = true
    else 
      Selection.active = false
    end
    
    Selection:update(dt)
  end
  
  function menu.draw()
    Selection:draw()
    
    for i = 1, #menu.options do
      Renderer.drawStatusMessage(menu.options[i].text, 75 * (i - 2))
    end
  end
  
  function menu.checkClick(x, y, button)
    if button == 1 then
      local on_button, index = menu:onButton(x, y)
      if on_button == 1 then 
        menu.options[index].action()
      end
    end
  end
  
  function menu:onButton(x, y, hover)
    x = x - Renderer.x_translation
    y = y - Renderer.y_translation
    
    for i = 1, #self.options do
      local x_valid = (x >= self.options[i].x) and (x <= (self.options[i].x + self.options[i].width))
      local y_valid = (y >= self.options[i].y) and (y <= (self.options[i].y + self.options[i].height))
      
      if x_valid and y_valid then
        return 1, i
      elseif hover and y_valid then
        return 2, i
      end
    end
    
    return 0
  end
    
  return menu
end

return Menu