
local blockSprite = love.graphics.newImage("images/blocks.png");

class "Stone" extends "Particle"

function Stone:init()
    self.super:init();
    self._duration = 10;
    self._velocity = Vector(math.random(-50, 50),math.random(-500, -300));
    self._angvelocity = math.random(-10, 10);
    self._color = 0;
    self._sectorx = math.random(0, 1);
    self._sectory = math.random(0, 1);
end

function Stone:setColor(color)
    self._color = color
end

function Stone:update(dt)
    self.super:update(dt);

    self._velocity = self._velocity + Vector(0, 1500 * dt);
    self:setOrigin(self:getOrigin() + self._velocity * dt);

    if (self:getLifeTime() > self._duration) then
        self:delete();
    end
end

function Stone:draw()
    local pos = self:getOrigin();

    love.graphics.setColor(255, 255, 255);
    --[[love.graphics.setScissor(
        pos.x + offsetX + self._sectorx * 11,
        pos.y + offsetY + self._sectory * 11 - 10,
        11,
        11
    );]]

    love.graphics.setScissor(
        pos.x + offsetX - 22*0.5 + 6,
        pos.y + offsetY - 22*0.5 + 6,
        22 * 1.5 - 12,
        22 * 1.5 - 12
    );
    --love.graphics.rectangle('fill', pos.x - 7, pos.y - 7, 15, 15);

    love.graphics.draw(blockSprite,
        pos.x + offsetX + (22 * 1.5 * 0.5) - 22*0.5,
        pos.y + offsetY + (22 * 1.5 * 0.5) - 22*0.5,
        self:getLifeTime() * self._angvelocity,
        --0,
        1.5,
        1.5,
        22 * self._color + 11,
        22 + 11
    );

    love.graphics.setScissor();

end