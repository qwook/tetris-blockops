
--bgm = love.audio.newSource("sound/robitnovski.mp3", "stream")
--bgm:setLooping(true);

local nightSprite = love.graphics.newImage("images/night.png");
local daySprite = love.graphics.newImage("images/communist.png");

class "Game" extends "GUI"

local MODE_MENU = 0;
local MODE_GAME = 0;

local font = love.graphics.newFont(14)

function Game:init()
    self.super:init();
    --love.audio.play(bgm)

    -- pause
    self._pausemenu = Pause:new();
    self._gameovermenu = GameOver:new();

    self._pausemenu:setVisible(false);
    self._gameovermenu:setVisible(false);
end

function Game:play()
    -- initialize all variables
    self._mode = MODE_MENU;
    self._board = {};
    -- make a tetromino
    self._tetra = Tetra:new(math.random(1, 7));
    -- make a battlefield
    self._battlefield = Battlefield:new();
    self._battlefield:setPos(Vector(240, 0));
    -- speed of the falling
    self._gravity = 0.1;
    self._nextGravity = self._gravity;
    self._height = 20;
    self._width = 10;
    -- needs to be false, checks if the board is overflowed
    self._overflow = false;
    -- wave
    self._wave = 0;
    self._time = 0;

    self._gameover = false;

    self._pausemenu:setVisible(false);
    self._gameovermenu:setVisible(false);
    
    self._streak = 0;
    self._laststreak = 0;

     -- initialize game board
    for i = 1, self._height do
        table.insert(self._board, {});
    end

    self:nextWave();
end

function Game:quit()
    self._pausemenu:setVisible(false);
    self._gameovermenu:setVisible(false);
end

function Game:getTime()
    return self._time;
end

function Game:newWave(wave)
    self._gravity = 1.75 - (wave/10);
    if (self._gravity < 0.1) then
        self._gravity = 0.1;
    end
end

function Game:nextWave()

    if (self._wave > 0) then
        shake(0.5, 4, 25);
    end

    for y, v in pairs(self._board) do
        for x, block in pairs(v) do
            for i = 1, 4 do
                local stone = Stone:new();
                stone:setColor(block:getColor());
                stone:setOrigin(block:getPos() * Block.size + Vector(Block.size/2, Block.size/2));
            end
        end
    end

    -- clear the board
    for i = 1, self._height do
        self._board[i] = {};
    end

    self._wave = self._wave + 1;
    self:newWave(self._wave);
    self._battlefield:newWave(self._wave);
end

function Game:getHeight()
    return self._height;
end

function Game:getWidth()
    return self._width;
end

function Game:setBoardPos(pos, piece)
    -- the board is overflowing! game over!
    if (not self._board[pos.y+1] or pos.y < 1) then
        self._overflow = true;
        return;
    end

    self._board[pos.y+1][pos.x+1] = piece;
end

function Game:getBoardPos(pos)
    if self._board[pos.y+1] then
        return self._board[pos.y+1][pos.x+1];
    end
    return nil;
end

function Game:getBattlefield()
    return self._battlefield;
end

function Game:canPlace(pos)
    return (not self:getBoardPos(pos)) and (pos.x >= 0 and pos.x < self._width and pos.y < self._height);
end

function Game:placeTetra()
    shake(0.1, 2, 20);
    self._tetra:place();
end

function Game:newTetra()
    self._tetra = Tetra:new(math.random(1, 7));
end

function Game:destroyRows()
    local y = 1;
    while (y < self._height) do
        y = y + 1;
        local v = self._board[y];

        if v then
            local count = 0;

            for x = 1, self._width do
                if (not v[x] or v[x]:getColor() == 4) then
                    count = count + 1;
                end
            end

            if (count == 0) then
                local explode_pos = v[6]:getPos() * 22;
                for x, block in pairs(v) do
                    for i = 1, 2 do
                        local stone = Stone:new();
                        stone:setColor(block:getColor());
                        stone:setOrigin(block:getPos() * Block.size + Vector(Block.size/2, Block.size/2));
                    end
                    v[x] = nil;
                end
                local explode = Explosion:new();
                explode:setOrigin( explode_pos );
                table.remove(self._board, y);
                y = y - 1;
                if (self._time - self._laststreak) < 3 then
                    self._streak = self._streak + 1;
                else
                    self._streak = 1;
                end
                self._laststreak = self._time;
            end
        end
    end

    local shots = self._height - #self._board;
    self._battlefield:shoot(shots);

    if #self._board < self._height then
        shake(0.15, 3, 20);

        for i = 1, self._height - #self._board do
            table.insert(self._board, 1, {});
        end

        for y, v in pairs(self._board) do
            for x, block in pairs(v) do
                block:setGoal(Vector(x-1, y-1));
            end
        end
    end

    if (shots > 0) then
        if (self._streak == 2) then
            print("DOUBLE KILL!");
        elseif (self._streak == 3) then
            print("TRIPLE KILL!");
        elseif (self._streak == 4) then
            print("QUADRUPLE KILL!");
        elseif (self._streak == 5) then
            print("PENTAKILL!");
        elseif (self._streak == 6) then
            print("HEXAKILL!");
        elseif (self._streak == 7) then
            print("KILL GATES!");
        elseif (self._streak == 8) then
            print("STEVE GIBS!");
        elseif (self._streak == 9) then
            print("REVOLUTION 9!");
        elseif (self._streak == 10) then
            print("DECIMATION!");
        end
    end

end

function Game:gravity()
    self._tetra:move(Vector(0, 1));
end

function Game:press(key)
    if self._gameover then
        if (key == "return" or key == "enter") then
            self:init();
        end
        return
    end

    if not self._pausemenu:isValid() then
        if (key == "up") then
            self._tetra:rotate();
        elseif (key == "left") then
            self._tetra:move(Vector(-1, 0));
        elseif (key == "right") then
            self._tetra:move(Vector(1, 0));
        elseif (key == "down") then
            self._tetra:move(Vector(0, 1));
        elseif (key == " ") then
            for i = 1, self._height + 1 do
                self._tetra:move(Vector(0, 1));
            end
        end
    end

    if (key == "escape") then
        self._pausemenu:setVisible(not self._pausemenu:isValid());
    end
end

function Game:release(key)

end

function Game:gameover()
    self._gameover = true;
    self._gameovermenu:setVisible(true);
    --self:init();
end

function Game:canUpdate()
    return not (self._pausemenu:isValid() or self._gameover);
end

function Game:update(dt)
    if not self:isValid() then
        return;
    end

    if self._pausemenu:isValid() or self._gameover then
        return;
    end

    self._time = self._time + dt;

    if (self._overflow) then
        self:gameover();
    end

    if (self:getTime() > self._nextGravity) then
        self:gravity();
        self._nextGravity = self:getTime() + self._gravity;
    end

    if (self._tetra:checkStuck()) then
        self:placeTetra();
        self:newTetra();
        self:destroyRows();
    end

    -- Update all the blocks on the board.
    for y, v in pairs(self._board) do
        for x, block in pairs(v) do
            block:update(dt);
        end
    end

    -- Update battlefield.
    self._battlefield:update(dt);
end

function Game:dropBlocks()
    shake(0.15, 3, 20);
    for i = 1, 8 do
        local x = math.random(0, 9)

        local block = Block:new();
        block:setPos(Vector(x, 1));
        block:setColor(4);

        offset = Vector(0, 0);

        for i = 1, game:getHeight() + 1 do
            offset = Vector(0, i);
            if not (game:canPlace(block:getPos() + offset)) then
                offset = Vector(0, i - 1);
                break;
            end
        end

        game:setBoardPos(block:getPos() + offset, block);
        block:setGoal(block:getPos() + offset);

        local count = 0;
        local v = self._board[block:getPos().y];
        for x = 1, game:getWidth() do
            if (not v[x]) then
                count = count + 1;
            end
        end

        if count == 0 then
            for x = 1, game:getWidth() do
                v[x]:setColor(4);
            end
        end
    end
end

function Game:draw()
    -- Draw game board
    --love.graphics.setColor(40, 40, 40);
    --love.graphics.rectangle("fill", 20, 20, 22*self._width, 22*self._height)
    love.graphics.setColor(100, 100, 100);
    love.graphics.draw(nightSprite, 20 + offsetX, 20 + offsetY + 29);

    if (self._battlefield:isDanger()) then
        
        love.graphics.setColor(255, 255, 255, 50 + math.sin(self._time * 6) * 50);
        love.graphics.draw(daySprite, 20 + offsetX, 20 + offsetY + 29);

    end

    -- Draw the falling tetra.
    self._tetra:draw();

    -- Draw all the blocks on the board.
    for y, v in pairs(self._board) do
        for x, block in pairs(v) do
            block:draw();
        end
    end

    -- Draw battlefield
    self._battlefield:draw();

    -- Draw UI elements
    love.graphics.setFont(font);
    love.graphics.setColor(255, 0, 0);
    love.graphics.print("Wave: " .. self._wave, 10, 10)
end
