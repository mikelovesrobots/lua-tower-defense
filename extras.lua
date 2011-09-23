function debug(string)
  if (DEBUG) then
    print(string)
  end
end

function between(val, min, max)
  return val >= min and val <= max
end

function math.dist(x1, y1, x2, y2)
  return ((x2-x1)^2+(y2-y1)^2)^0.5
end

function set_color(rgb)
  love.graphics.setColor(rgb[1], rgb[2], rgb[3])
end

function round(num)
  if num >= 0 then return math.floor(num+.5)
  else return math.ceil(num-.5) end
end

function math.angle(x1, y1, x2, y2)
  return math.atan2(y2-y1,x2-x1)
end

function math.calc_destination(x1, y1, angle, distance)
  return x1 + (distance * math.cos(angle)), y1 + (distance * math.sin(angle))
end

