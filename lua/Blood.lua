
class "Blood" extends "Particle"

function Blood:init()
    self.super:init();
    self._duration = 10;
    self._velocity = Vector(0,0,0);
end

function Blood:setVelocity(vel)
    self._velocity = vel:copy();
end

function Blood:update(dt)
    self.super:update(dt);

    self:setOrigin(self:getOrigin() + self._velocity * dt);
    self._velocity = self._velocity:approach(Vector(0,0,0), dt * 1500)

    if (self:getLifeTime() > self._duration) then
        self:delete();
    end
end

function Blood:draw()
    local pos = self:getOrigin();

    love.graphics.setColor(255, 0, 0, 255 - (self:getLifeTime() / self._duration * 255));
    love.graphics.rectangle('fill', pos.x - 7 + offsetX, pos.y - 7 + offsetY, 15, 15);
end