local State = {}

function State.init()
  State.options_menu = "options menu"
  State.countdown = "countdown"
  State.main_menu = "main menu"
  State.life_lost = "life lost"
  State.destroyed = "destroyed"
  State.running = "running"
  State.paused = "paused"
  State.normal = "normal"

  State.current = State.main_menu
  State.last = State.current
  State.is_paused = false
end

State.init()

return State