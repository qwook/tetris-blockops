
local muzzleflash = love.graphics.newImage("images/muzzleflash.png");

class "Explosion" extends "Particle"

function Explosion:init()
    self.super:init();
    self._duration = 0.25;
end

function Explosion:update(dt)
    self.super:update(dt);

    if (self:getLifeTime() > self._duration) then
        self:delete();
    end
end

function Explosion:draw()
    local pos = self:getOrigin();

    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(muzzleflash, pos.x + offsetX, pos.y + offsetY + 11, 0, 4 + (self:getLifeTime() / self._duration)*4, 0.5 * (self._duration - self:getLifeTime()) / self._duration, 37, 60);
end

