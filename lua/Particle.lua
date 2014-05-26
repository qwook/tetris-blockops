
class "Particle"

particles = {};

function Particle:init()
    self._updateInGame = false;
    self._queueDelete = false;
    self._lifeTime = 0;
    self._origin = Vector(0,0,0);
    self._end = Vector(0,0,0);
    table.insert(particles, self);
end

function Particle:setOrigin(pos)
    self._origin = pos:copy();
end

function Particle:setEnd(pos)
    self._end = pos:copy();
end

function Particle:getOrigin(pos)
    return self._origin;
end

function Particle:getEnd(pos)
    return self._end;
end

function Particle:getLifeTime()
    return self._lifeTime;
end

function Particle:update(dt)
    self._lifeTime = self._lifeTime + dt;
end

function Particle:delete()
    self._queueDelete = true;
end
