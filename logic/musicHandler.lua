local MusicHandler = {}

function MusicHandler.init()
  MusicHandler.menu = MusicHandler.loadSound("themes/menu.mp3", true, 1.0, 0.5)
  
  MusicHandler.enemy = MusicHandler.loadSound("themes/enemy.mp3", true, 1.0, 0.01)
  
  MusicHandler.current = MusicHandler.menu
  
  MusicHandler.fadeOut = false
  MusicHandler.fadeIn = false
end

function MusicHandler.loadSound(name, looping, pitch, volume, static)
  local Sound = {}
  
  if static then
    Sound.audio = love.audio.newSource("assets/sounds/" .. name, "static")
  else
    Sound.audio = love.audio.newSource("assets/sounds/" .. name)
  end
  
  Sound.audio:setLooping(looping or true)
  Sound.audio:setPitch(pitch or 1)
  Sound.audio:setVolume(volume or 1.0)
  
  function Sound:start()
    self.audio:play()
  end
  
  function Sound:toggle()
    if self.audio:isPaused() then
      self.audio:resume()
    else
      self.audio:pause()
    end
  end
  
  function Sound:stop()
    self.audio:stop()
  end
  
  function Sound:setVolume(volume)
    return Sound.audio:setVolume(volume)
  end

  function Sound:setPitch(pitch)
    return Sound.audio:setPitch(pitch)
  end
  
  function Sound:setLooping(looping)
    return Sound.audio:setLooping(looping)
  end

  function Sound:getVolume()
    return Sound.audio:getVolume()
  end

  function Sound:getPitch()
    return Sound.audio:getPitch()
  end
  
  function Sound:getLooping()
    return Sound.audio:getLooping()
  end
  
  return Sound
end

function MusicHandler.fadeTo(song, in1p, out1p, in2p, out2p, outTime, inTime)
  local in1, out1, in2, out2 = in1p / 100, out1p / 100, in2p / 100, out2p / 100
  MusicHandler.next = song
  MusicHandler.fadeOut = true
  MusicHandler.outStep = (in1 - out1) / (outTime * 60)
  MusicHandler.inStep = (out2 - in2) / (inTime * 60)
  MusicHandler.outStop = out1
  MusicHandler.inStop = out2
  MusicHandler.outStart = in2
end

function MusicHandler.update(dt)
  if MusicHandler.fadeOut then
    if MusicHandler.current:getVolume() > MusicHandler.outStop then
      MusicHandler.current:setVolume(MusicHandler.current:getVolume() - MusicHandler.outStep)
    else
      MusicHandler.fadeOut = false
      MusicHandler.fadeIn = true
      
      MusicHandler.current:stop()
      
      MusicHandler.current = MusicHandler.next
      
      MusicHandler.current:setVolume(MusicHandler.outStart)
      MusicHandler.current:start()
    end
  end
  
  if MusicHandler.fadeIn then
    if MusicHandler.current:getVolume() < MusicHandler.inStop then
      MusicHandler.current:setVolume(MusicHandler.current:getVolume() + MusicHandler.inStep)
    else
      MusicHandler.fadeIn = false
      MusicHandler.current:setVolume(MusicHandler.inStop)
    end
  end
end

function MusicHandler.play()
  MusicHandler.current:start()
end

MusicHandler.init()

return MusicHandler