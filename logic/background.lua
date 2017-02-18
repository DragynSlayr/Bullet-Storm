local Background = {}

function Background.load()
  Background.title = SpriteHandler.loadLargeSprite("background/brick.tga", 1, 1, 1920, 1080)
  
  Background.bamboo = SpriteHandler.loadLargeSprite("background/bamboo.tga", 1, 1, 1920, 1080)
  
  Background.sprite = Background.title
  Background.alpha = 255
end

function Background.draw()
  local r, g, b, a = love.graphics.getColor()
  
  love.graphics.setColor(r, g, b, Background.alpha)
  
  Renderer.drawObject(Background)
  
  love.graphics.setColor(r, g, b, a)
end

function Background.fadeTo(bg, in1p, out1p, in2p, out2p, outTime, inTime)
  local in1, out1, in2, out2 = (in1p / 100) * 255, (out1p / 100) * 255, (in2p / 100) * 255, (out2p / 100) * 255
  Background.next = bg
  Background.fadeOut = true
  Background.outStep = (in1 - out1) / (outTime * 60)
  Background.inStep = (out2 - in2) / (inTime * 60)
  Background.outStop = out1
  Background.inStop = out2
  Background.outStart = in2
end

function Background.update(dt)
  if Background.fadeOut then
    if Background.alpha > Background.outStop then
      Background.alpha = Background.alpha - Background.outStep
    else
      Background.fadeOut = false
      Background.fadeIn = true
      
      Background.sprite = Background.next
      
      Background.alpha = Background.outStart
    end
  end
  
  if Background.fadeIn then
    if Background.alpha < Background.inStop then
      Background.alpha = Background.alpha + Background.inStep
    else
      Background.fadeIn = false
      Background.alpha = Background.inStop
    end
  end
end

Background.load()

return Background