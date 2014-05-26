
class "Tetra"

local pieces = {
    -- I
    { Vector(0, 1), Vector(0, 0), Vector(0, 2), Vector(0, 3) };
    -- J
    { Vector(1, 0), Vector(0, 0), Vector(2, 0), Vector(2, 1) };
    -- L
    { Vector(1, 0), Vector(0, 0), Vector(2, 0), Vector(0, 1) };
    -- O
    { Vector(1, 0), Vector(0, 0), Vector(1, 1), Vector(0, 1) };
    -- S
    { Vector(1, 0), Vector(1, 1), Vector(0, 1), Vector(2, 0) };
    -- T
    { Vector(1, 0), Vector(0, 0), Vector(2, 0), Vector(1, 1) };
    -- Z
    { Vector(1, 0), Vector(1, 1), Vector(0, 0), Vector(2, 1) };
}

function Tetra:init(_piece)
    self._tetra = {};
    self._piece = _piece;
    self._revolution = 0;
    self._stuck = 0;

    local z = math.random(0,150);
    --local color = {math.random(150,255),z,z};
    local color = math.random(0, 3);

    for i = 1, 4 do
        local block = Block:new();
        table.insert(self._tetra, block);
        block:setPos(pieces[_piece][i] + Vector(5, 0) - pieces[_piece][1]);
        block:setColor(color);
    end

end

function Tetra:move(offset)
    for i = 1, 4 do
        local block = self._tetra[i];
        if (not game:canPlace(block:getPos() + offset)) then
            if (offset.y > 0) then
                self._stuck = self._stuck + 1;
            end
            return;
        end
    end

    for i = 1, 4 do
        local block = self._tetra[i];
        block:setPos(block:getPos() + offset);
    end
end

function Tetra:checkStuck()
    if (self._stuck > 0) then
        return true;
    end
end

function Tetra:calculateOrigin()
    --[[local first = self._tetra[1]:getPos();
    local lowestX, lowestY = first.x, first.y;
    for i = 2, 4 do
        local pos = self._tetra[i]:getPos();
        if (pos.x < lowestX) then
            lowestX = pos.x;
        end
        if (pos.y < lowestY) then
            lowestY = pos.y;
        end
    end
    return Vector(lowestX, lowestY);]]
    return self._tetra[1]:getPos();
end

function Tetra:rotate()
    if (self._piece == 4) then
        return;
    end

    self._revolution = (self._revolution + 1) % 4

    local origin = self._tetra[1]:getPos();
    local rotation = Vector(-1, 1)

    if (self._piece == 1 or self._piece == 5 or self._piece == 7) then
        if (self._revolution == 1 or self._revolution == 3) then
            rotation = Vector(1, -1)
        end
    end

    for i = 1, 4 do
        local block = self._tetra[i];
        local pos = block:getPos() - origin;
        if (not game:canPlace(Vector(pos.y * rotation.x, pos.x * rotation.y) + origin)) then
            return;
        end
    end

    for i = 1, 4 do
        local block = self._tetra[i];
        local pos = block:getPos() - origin;
        block:setPos(Vector(pos.y * rotation.x, pos.x * rotation.y) + origin);
    end

end

function Tetra:place()
    for i = 1, 4 do
        local block = self._tetra[i];
        game:setBoardPos(block:getPos(), block);
    end
end

function Tetra:draw()

    -- this traces the blocks downwards a few times to see where it's going to land.
    local ghost = Vector(0, 0);
    for i = 1, game:getHeight() + 1 do
        local offset = Vector(0, i)

        local free = 0;
        for i = 1, 4 do
            local block = self._tetra[i];
            if (game:canPlace(block:getPos() + offset)) then
                free = free + 1;
            else
                break;
            end
        end

        if (free == 4) then
            ghost = offset;
        else
            break;
        end
    end
    -- we got the ghost, now we gotta draw it.

    for i = 1, 4 do
        self._tetra[i]:draw(ghost, {255, 255, 255, 100});
    end

    -- we draw the actual block over the ghost.
    for i = 1, 4 do
        self._tetra[i]:draw();
    end

end