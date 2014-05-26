
local tracer = love.graphics.newImage("images/tracer.png");

class "Tracer" extends "Particle"

function Tracer:init()
    self.super:init();
    self._duration = 0.1;
end

function Tracer:update(dt)
    self.super:update(dt);

    if (self:getLifeTime() > self._duration) then
        self:delete();
    end
end

function Tracer:draw()
    local startpos = self:getOrigin() + Vector(10, 15);
    local endpos = self:getEnd() + Vector(10, 15);

    local fakeStartPos = (endpos - startpos) * (self:getLifeTime() / self._duration)*0.9 + startpos;
    local fakeEndPos = (endpos - startpos) * (self:getLifeTime() / self._duration) + startpos;

    love.graphics.setColor(255, 255, 255);
    love.graphics.line(fakeStartPos.x + offsetX, fakeStartPos.y + offsetY, fakeEndPos.x + offsetX, fakeEndPos.y + offsetY)
    love.graphics.draw(tracer, fakeStartPos.x + offsetX, fakeStartPos.y + offsetY, (fakeEndPos - fakeStartPos):angle() - math.pi / 2, 1, 1, 29, 12);
end

