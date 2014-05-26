
local blockSprite = love.graphics.newImage("images/blocks.png");

class "Block"

Block.size = 22;

function Block:init()
    self._origin = Vector(0, 0);
    self._goal = Vector(0, 0);
    self._size = Block.size;
    self._color = math.random(0, 3);
end

function Block:setColor(color)
    self._color = color;
end

function Block:getColor()
    return self._color;
end

function Block:setPos(pos)
    self._origin = pos:copy();
    self._goal = self._origin;
end

function Block:setGoal(pos)
    self._original = self._origin;
    self._time = 0;
    self._goal = pos:copy();
end

function Block:getPos()
    return self._origin:copy();
end

local function outBounce(t, b, c, d)
  t = t / d
  if t < 1 / 2.75 then
    return c * (7.5625 * t * t) + b
  elseif t < 2 / 2.75 then
    t = t - (1.5 / 2.75)
    return c * (7.5625 * t * t + 0.75) + b
  elseif t < 2.5 / 2.75 then
    t = t - (2.25 / 2.75)
    return c * (7.5625 * t * t + 0.9375) + b
  else
    t = t - (2.625 / 2.75)
    return c * (7.5625 * t * t + 0.984375) + b
  end
end

function Block:update(dt)
    if (self._goal ~= self._origin) then
        self._time = self._time + dt * 2;

        local dist = self._original:distance(self._goal);
        local decay = (1 - (self._time))^2;
        self._origin = self._original:approach(self._goal, outBounce(self._time, 0, dist, 1));
        if self._time * dist > dist then
            self._origin = self._goal;
        end
    end
end

function Block:draw(ghost, color)
    --love.graphics.setColor(unpack(self._color));
    --[[love.graphics.setColor(50, 50, 50);
    love.graphics.rectangle("fill", self._origin.x * self._size + offsetX, self._origin.y * self._size + offsetY, self._size, self._size)
    love.graphics.setColor(50, 50, 50);
    love.graphics.rectangle("line", self._origin.x * self._size + 1 + offsetX, self._origin.y * self._size + 1 + offsetY, self._size, self._size)]]

    ghost = ghost or Vector(0, 0);
    color = color or {255, 255, 255, 255};

    love.graphics.setColor(unpack(color));
    love.graphics.setScissor(
        self._origin.x * self._size + offsetX + ghost.x * self._size + 20,
        self._origin.y * self._size + offsetY + ghost.y * self._size + 20,
        self._size,
        self._size
    );

    love.graphics.draw(blockSprite,
        self._origin.x * self._size + offsetX - 22 * self._color + ghost.x * self._size + 20,
        self._origin.y * self._size + offsetY + ghost.y * self._size + 20
    );

    love.graphics.setScissor();
end
