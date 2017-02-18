local LifeLost = {}

function LifeLost.init()
  LifeLost.starting_sprite = Player.idle_sprite
  
  Player.sprite = Player.hit_sprite
  Player.sprite.current_frame = 1
  
  LifeLost.time = 0
  LifeLost.max_time = 1.15
end

function LifeLost.update(dt)
  LifeLost.time = LifeLost.time + dt
  
  if LifeLost.time >= LifeLost.max_time then
    Player.sprite = LifeLost.starting_sprite
    Player.state = State.normal
  end
end

return LifeLost