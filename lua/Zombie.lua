
-- brains

local zombieSheet = love.graphics.newImage("images/juan_sprite_sheet.png");
local shadowSprite = love.graphics.newImage("images/shadow.png");

class "Zombie"

function Zombie:init()
    self._origin = Vector(0, 0);
    self._offset = Vector(0, 0);
    self._speed = 10;
    self._velocity = 0;
    self._health = 1;
    self._queueDeath = false;
    self._deathTime = 0;
    self._time = 0;
end

function Zombie:setHealth(health)
    self._health = health;
end

function Zombie:setSpeed(speed)
    self._speed = speed;
end

function Zombie:setPos(pos)
    self._origin = pos:copy();
end

function Zombie:getPos()
    return self._origin:copy();
end

function Zombie:setOffset(pos)
    self._offset = pos:copy();
end

function Zombie:getNeighbor()
    local neighbor = self:getPos();
    local dist = 5000;
    for _, zombie in pairs( game:getBattlefield():getZombies() ) do
        if zombie ~= self then
            local pos = zombie:getPos()
            local d = pos:distance(self:getPos());
            if (d < dist) then
                dist = d;
                neighbor = pos;
            end
        end
    end

    return neighbor, dist;
end

function Zombie:shoot()
    local velocity = (self:getPos() - game:getBattlefield():getSoldier():getPos()):normal();
    for i = 1, 4 do
        local blood = Blood:new();
        blood:setOrigin(self:getPos() + self._offset);
        blood:setVelocity((velocity+Vector(math.random(-10, 10)/20, math.random(0, 10)/20)):normal() * math.random(450, 500));
    end

    local olHealth = self._health;
    self._health = self._health - 1;
    if (self._health <= 0 and olHealth > 0) then
        game:getBattlefield():zombieDied();
    end
end

function Zombie:getHealth()
    return self._health;
end

function Zombie:die()
    self._queueDeath = true;
end

function Zombie:update(dt)

    if (self._health > 0) then
        local pos = self:getPos();

        local neighbor, dist = self:getNeighbor();
        local gravitate = pos:approach(self:getNeighbor(), self._speed * dt);
        local goal = pos + Vector( 0, -1 * self._speed * dt );
        if (dist < 40) then
            local force = (pos - self:getNeighbor()) * dt * 2;
            self._velocity = self._velocity + force.x/2;
        else
            self._velocity = self._velocity + (gravitate.x - pos.x);
        end

        local soldier = game:getBattlefield():getSoldier():getPos();
        if (pos.y < 75) then
            self._velocity = self._velocity / 2 + ((soldier - pos):normal()).x * 10;
        end

        if (pos.x < 10) then
            self._velocity = self._velocity / 2 + (22 - pos.x)
        elseif (pos.x > game:getWidth() * 22 - 10) then
            self._velocity = self._velocity / 2 + ((game:getWidth() * 22 - 22) - pos.x)
        end

        goal.x = goal.x + (self._velocity * dt * (self._speed/10));

        self:setPos( goal );

        self._time = self._time + dt;

        if pos.y < 25 then
            if game:getBattlefield()._zombiesLeft == 1 then
                game:gameover();
            else
                game:dropBlocks();
            end
            self:shoot();
        end
    else
        self._deathTime = self._deathTime + dt;
        if ( self._deathTime ) > 1 then
            self:die();
        end
    end

end

local SPRITE_OFFSET_X = -25

function Zombie:draw()
    if (self._health > 0) then
        love.graphics.setColor(255, 255, 255);
    else
        love.graphics.setColor(50, 50, 50, 50);
    end

    love.graphics.draw(shadowSprite, 
        SPRITE_OFFSET_X +
        self._origin.x + self._offset.x -- base position
            + offsetX
            + 1, -- shake
        self._origin.y + self._offset.y -- base position
            + offsetY -- shake
            + 60
            + math.sin(self._time*(self._speed/2.5) + 0.2) * (self._speed/10)
    );

    -- draw the zombie!
    love.graphics.setScissor(SPRITE_OFFSET_X + self._origin.x + self._offset.x + offsetX, self._origin.y + self._offset.y + offsetY, 67, 111);

    -- draw leg
    love.graphics.draw(zombieSheet,
        SPRITE_OFFSET_X +
        self._origin.x + self._offset.x -- base position
            + offsetX -- shake
            - 67 * (math.floor(self._time*(self._speed/5)) % 6),
        self._origin.y + self._offset.y -- base position
            + offsetY -- shake
            - 111 -- subsect of sprite
            + math.sin(self._time*(self._speed/2.5) - 0.05) * (self._speed/9.5)
    );

    local t = (math.floor(self._time * 4.5) % 5);
    if (t > 2) then
        t = 5 - t;
    end


    -- draw torso
    love.graphics.draw(zombieSheet,
        SPRITE_OFFSET_X +
        self._origin.x + self._offset.x -- base position
            + offsetX -- shake
            - 67 * t,
        self._origin.y + self._offset.y -- base position
            + offsetY -- shake
            + math.sin(self._time*(self._speed/2.5) + 0.2) * (self._speed/10)
    );

    love.graphics.setScissor();

end
