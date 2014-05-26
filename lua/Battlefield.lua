
-- Where the zombies spawn and shit

bulletFire = love.audio.newSource("sound/fire.mp3", "static")
zombieHits = {
    love.audio.newSource("sound/hit1.mp3", "static");
    love.audio.newSource("sound/hit2.mp3", "static");
    love.audio.newSource("sound/hit3.mp3", "static");
}
fleshHit = love.audio.newSource("sound/fleshhit.mp3", "static");

local grassSprite = love.graphics.newImage("images/grass.png");
local fadeSprite = love.graphics.newImage("images/overlay.png");

class "Battlefield"

function Battlefield:init()
    self._soldier = Soldier:new();
    self._soldier:setPos(Vector(100, 10));
    self._origin = Vector(400, 20);
    self._zombies = {};
    self._zombieCount = 5;
    self._zombiesLeft = 5;
    self._zombieSpawnTime = 3;
    self._zombieHealth = 1;
    self._zombieSpeed = 10;
    self._nextZombieSpawn = 0;
    self._nextShot = 0;
    self._shots = 0;
    self._zombieHit = 0;
end

function Battlefield:newWave(wave)
    self._zombieCount = 4 + wave * 3
    self._zombiesLeft = self._zombieCount;
    self._zombieHealth = math.floor(wave * 0.1) + 1;
    self._nextZombieSpawn = 0;
    self._zombieSpeed = 20 + (wave / 5);
    self._zombieSpawnTime = 2 - (wave / 20);
    if (self._zombieSpawnTime < 1) then
        self._zombieSpawnTime = 1;
    end
end

function Battlefield:spawnZombie()
    local zombie = Zombie:new();
    zombie:setHealth(self._zombieHealth);
    zombie:setPos(Vector(math.random(0, game:getWidth() * 22), math.random(game:getHeight() * 22, game:getHeight() * 22 + 22)));
    zombie:setOffset(self._origin);
    zombie:setSpeed(math.random(math.ceil(self._zombieSpeed - (self._zombieSpeed/2)), math.ceil(self._zombieSpeed)));

    self._zombieCount = self._zombieCount - 1;
    table.insert(self._zombies, zombie);
end

function Battlefield:setPos(pos)
    self._soldier:setOffset(self._origin);

    for _, zombie in pairs(self._zombies) do
        zombie:setOffset(pos);
    end
end

function Battlefield:getPos()
    return self._origin
end

function Battlefield:zombieDied()
    self._zombiesLeft = self._zombiesLeft - 1;
end

function Battlefield:update(dt)
    local i = 0;
    while (i < #self._zombies) do
        i = i + 1;
        if (self._zombies[i]._queueDeath) then
            table.remove(self._zombies, i)
            i = i - 1;
        end
    end

    self._soldier:update(dt);

    -- update the zombies
    for _, zombie in pairs(self._zombies) do
        zombie:update(dt);
    end

    -- loop through the zombies and get the closest zombies
    local closestZombie;
    local closest = 400000;
    for _, zombie in pairs(self._zombies) do
        local d = zombie:getPos().y;
        if (zombie:getHealth() > 0 and zombie:getPos().y < closest) then
            closestZombie = zombie;
            closest = d;
        end
    end

    if (closestZombie) then
        self._soldier:setAngle( (closestZombie:getPos() - self._soldier:getPos()):angle() );
    end

    if (self._nextZombieSpawn < game:getTime() and self._zombieCount > 0) then
        self:spawnZombie();
        self._nextZombieSpawn = game:getTime() + self._zombieSpawnTime;
    end

    if (self._zombiesLeft <= 0) then
        game:nextWave();
    end

end

function Battlefield:getZombies()
    return self._zombies;
end

function Battlefield:getSoldier()
    return self._soldier;
end

function Battlefield:shoot(shots)

    self._nextShot = love.timer.getTime() / 1000;
    local fired = shots;
    if (fired > 0) then
        love.audio.stop(bulletFire);
        love.audio.play(bulletFire);
        timer(0, function()
            love.audio.stop(fleshHit);
            love.audio.play(fleshHit);
        end)
    end
    while (fired > 0) do
        timer(0.15, function()
            self._shots = self._shots + 1;
            self._zombieHit = ((self._zombieHit + 1) % #zombieHits)
            love.audio.stop(zombieHits[self._zombieHit + 1]);
            love.audio.play(zombieHits[self._zombieHit + 1]);
        end)

        local closestZombie;
        local closest = 400000;
        local count = 0;
        for _, zombie in pairs(self._zombies) do
            local d = zombie:getPos().y;
            if (zombie:getHealth() > 0 and zombie:getPos().y < closest) then
                closestZombie = zombie;
                closest = d;
                count = count + 1;
            end
        end

        if (count == 0) then
            return;
        end

        if (closestZombie) then
            self._soldier:setAngle( (closestZombie:getPos() - self._soldier:getPos()):angle() );
            while (fired > 0 and closestZombie:getHealth() > 0) do
                local tracer = Tracer:new();
                tracer:setOrigin(self._soldier:getPos() + self._origin + Vector(self._soldier._muzzleoff*1.9 + 3, 50));
                tracer:setEnd(closestZombie:getPos() + self._origin);
                closestZombie:shoot();
                fired = fired - 1;
            end
        end

        self._soldier:recoil();
    end
end

function Battlefield:isDanger()
    for _, zombie in pairs(self._zombies) do
        if (zombie:getPos().y < 60) then
            return true;
        end
    end
    return false;
end

function Battlefield:draw()
    -- Draw game board
    --love.graphics.setColor(40, 40, 40);
    --love.graphics.rectangle("fill", self._origin.x, self._origin.y, 22*game:getWidth(), 22*game:getHeight())
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(grassSprite, self._origin.x + offsetX, self._origin.y + offsetY);

    self._soldier:draw();

    table.sort( self._zombies, function(a, b)
        return a._origin.y < b._origin.y;
    end)

    for _, zombie in pairs(self._zombies) do
        zombie:draw();
    end

    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(fadeSprite, self._origin.x - 20, self._origin.y - 20, 0, 1.5, 1);
end
