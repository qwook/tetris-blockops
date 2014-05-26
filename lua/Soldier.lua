
-- Guy who shoots stuff

local soldierSheet = love.graphics.newImage("images/will_sprite_sheet.png");
local muzzleflash = love.graphics.newImage("images/muzzleflash.png");
local grassSprite = love.graphics.newImage("images/grass_m.png");
local shadowSprite = love.graphics.newImage("images/shadow.png");

class "Soldier"

function Soldier:init()
    self._origin = Vector(0, 0);
    self._offset = Vector(0, 0);
    self._angle = 0;

    self._spriteX = 0;
    self._spriteY = 0;

    self._life = 0;
    self._recoil = 0;
    self._muzzleoff = 0;
end

function Soldier:setOffset(pos)
    self._offset = pos:copy();
end

function Soldier:setPos(pos)
    self._origin = pos:copy();
end

function Soldier:getPos()
    return self._origin:copy();
end

function Soldier:update(dt)
    self._life = self._life + dt;
    if (self._recoil > 0) then
        self._recoil = self._recoil - dt*5;
    end
end

function Soldier:recoil()
    self._recoil = 1;
end

function Soldier:setAngle(ang)

    if (self._recoil > 0) then
        return;
    end

    self._angle = ang;

    local angle = math.deg(ang + 2);
    -- 0 - 7
    if (angle > 230) then
        self._spriteX = 0;
        self._muzzleoff = -8
    elseif (angle > 210) then
        self._spriteX = 1;
        self._muzzleoff = -7
    elseif (angle > 205) then
        self._spriteX = 2;
        self._muzzleoff = -6
    elseif (angle > 190) then
        self._spriteX = 3;
        self._muzzleoff = 0
    elseif (angle > 185) then
        self._spriteX = 4;
        self._muzzleoff = 1
    elseif (angle > 160) then
        self._spriteX = 5;
        self._muzzleoff = 5
    elseif (angle > 0) then
        self._spriteX = 6;
        self._muzzleoff = 5
    end
end

local SPRITE_OFFSET_X = -33

function Soldier:draw()

    local recoil_offset = 0;
    if (self._recoil > 0) then
        local p = 1 - self._recoil;
        recoil_offset = (math.cos((p * 2 * math.pi)) - 1) / (2) * 8;
    end

    if (self._recoil > 0) then
        love.graphics.setColor(255, 255, 255, self._recoil * 255);
        love.graphics.draw(grassSprite, game:getBattlefield():getPos().x + offsetX, game:getBattlefield():getPos().y + offsetY);
    end

    love.graphics.setColor(255, 255, 255);

    love.graphics.draw(shadowSprite, self._origin.x + self._offset.x + offsetX - 25, self._origin.y + self._offset.y + offsetY + 40);

    -- lets draw the guy!
    love.graphics.setScissor(SPRITE_OFFSET_X + self._origin.x + self._offset.x + offsetX, self._origin.y + self._offset.y + offsetY, 84, 98);

        -- draw leg
        love.graphics.draw(soldierSheet,
            SPRITE_OFFSET_X +
            self._origin.x + self._offset.x -- base position
                + offsetX, -- shake
            self._origin.y + self._offset.y -- base position
                + offsetY -- shake
                - 98 -- subsect of sprite
        );

        -- draw torso
        love.graphics.draw(soldierSheet,
            SPRITE_OFFSET_X +
            self._origin.x + self._offset.x -- base position
                + offsetX -- shake
                - self._spriteX * 84, -- subsect of sprite
            self._origin.y + self._offset.y -- base position
                + offsetY -- shake
                - self._spriteY * 98 -- subsect of sprite
                + math.sin((self._life + 0.3)*5) -- breathing
                + recoil_offset -- recoils the gun back when shot
        );

        -- draw head
        love.graphics.draw(soldierSheet,
            SPRITE_OFFSET_X +
            self._origin.x + self._offset.x -- base position
                + offsetX, -- shake
            self._origin.y + self._offset.y -- base position
                + offsetY -- shake
                - 2 * 98 -- subsect of sprite
                + math.sin(self._life*5) -- breathing
        );

    love.graphics.setScissor();

    -- we're piggybacking on the recoil attribute
    -- just draw the muzzle when we're recoiling
    if (self._recoil > 0) then
        love.graphics.draw(muzzleflash,
            SPRITE_OFFSET_X +
            self._origin.x + self._offset.x
                + offsetX -- shake
                + 35 -- tiny offset
                + self._muzzleoff, -- muzzle offset, determined by angle of gun.
            self._origin.y + self._offset.y
                + offsetY -- shake
                + math.sin((self._life + 0.3)*5) -- breathing (???)
                + recoil_offset + 30, -- recoil (???)
            -- angle of muzzleflash
            self._angle - math.pi/2,
            -- width and height of muzzle flash
            1 - 1 * (1 - self._recoil), -- squeeze together over time
            0.75 + 0.25 * (self._recoil), -- get taller over time
            -- center of sprite
            37, -35
        );
    end

end
