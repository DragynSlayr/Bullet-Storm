local MathHelper = {}

function MathHelper.load()
  math.randomseed(os.time())
  math.random(); math.random(); math.random()
end

function MathHelper.getCosSin(angle)
  local cos_angle = math.cos(angle)
  local sin_angle = math.sqrt(1 - (cos_angle * cos_angle))
  cos_angle = math.sqrt(1 - (sin_angle * sin_angle))
  
  return cos_angle, sin_angle
end

function MathHelper.rotate(x, y, angle)
  local cos_angle, sin_angle = MathHelper.getCosSin(angle)
  
  local rotated_x = (cos_angle * x) - (sin_angle * y)
  local rotated_y = (sin_angle * x) + (cos_angle * y)
  
  return rotated_x, rotated_y
end

function MathHelper.getUnitVector(x, y)
  local distance = MathHelper.getLength(x, y)
  return x / distance, y / distance
end

function MathHelper.randomSign()
  if math.random(0, 1) == 1 then
    return 1
  else
    return -1
  end
end

function MathHelper.getDistanceBetween(a, b)
  local x_dist = a.x - b.x
  local y_dist = a.y - b.y
  
  x_dist = x_dist * x_dist
  y_dist = y_dist * y_dist
  
  return math.sqrt(x_dist + y_dist)
end

function MathHelper.getAngleBetween(a, b)
  return math.atan2(a.y - b.y, a.x - b.x) + (math.pi / 2)
end

function MathHelper.getLength(x, y)
  return math.sqrt((x * x) + (y * y))
end

function MathHelper.random(lower, upper)
  if upper then
    return math.random(lower, upper)
  else
    return math.random(lower)
  end
end

function MathHelper.getRandomUnitStart(rad)
  local rand_num = (math.random() * 2) - 1
  local radius = rad or (love.graphics:getHeight() / 2)
  
  local x = rand_num * radius
  local y = math.sqrt((radius * radius) - (x * x))
  
  if math.random(0, 1) == 1 then
    y = -y
  end
  
  return x, y
end

MathHelper.load()

return MathHelper