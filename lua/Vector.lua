
class "_Vector"

function Vector(x, y)
    return _Vector:new(x, y);
end

function _Vector:init(x, y)
    self.x = x;
    self.y = y;
end

function _Vector:copy()
    return _Vector:new(self.x, self.y);
end

function _Vector:normal()
    local d = self:length();
    return _Vector:new(self.x / d, self.y / d);
end

function _Vector:length()
    return math.sqrt(self.x^2 + self.y^2);
end

function _Vector:distance(b)
    return (self - b):length();
end

function _Vector:approach(goal, p)
    if (self == goal) then return self:copy() end
    local delta = (goal - self):normal();
    local newpos = self + delta * p;
    if (delta.x > 0 and newpos.x > goal.x) or (delta.x < 0 and newpos.x < goal.x) then
        newpos.x = goal.x;
    end
    if (delta.y > 0 and newpos.y > goal.y) or (delta.y < 0 and newpos.y < goal.y) then
        newpos.y = goal.y;
    end
    return newpos;
end

function _Vector:lerp(goal, p)
    if (self == goal) then return self:copy() end
    local delta = (goal - self);
    local newpos = self + delta * p;
    if (delta.x > 0 and newpos.x > goal.x) or (delta.x < 0 and newpos.x < goal.x) then
        newpos.x = goal.x;
    end
    if (delta.y > 0 and newpos.y > goal.y) or (delta.y < 0 and newpos.y < goal.y) then
        newpos.y = goal.y;
    end
    return newpos;
end

function _Vector:angle()
    local normal = self:normal();
    return math.atan2(normal.y, normal.x);
end

function _Vector.mt.__add(a, b)
    return Vector(a.x + b.x, a.y + b.y);
end

function _Vector.mt.__sub(a, b)
    return Vector(a.x - b.x, a.y - b.y);
end

function _Vector.mt.__div(a, b)
    return Vector(a.x / b, a.y / b);
end

function _Vector.mt.__mul(a, b)
    return Vector(a.x * b, a.y * b);
end

function _Vector.mt.__eq(a, b)
    return a.x == b.x and a.y == b.y;
end

