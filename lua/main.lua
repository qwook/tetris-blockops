
--[[

todo:
    Add Menu (start menu)
    Add Pause menu
    Add Game Over menu, show waves accomplished.
    Add Graphics
        -- tetris blocks
        -- debris
        -- new wave text
        -- will, zombies
    Add transitions

]]

-- default font
font = love.graphics.newFont(14)

require("class");
require("Gui");
require("Button");
require("Vector");
require("Game");
require("Block");
require("Tetra");
require("Battlefield");
require("Soldier");
require("Zombie");
require("Pause");
require("MainMenu");
require("GameOver");
require("Particle");
require("Tracer");
require("Explosion");
require("Vein");
require("Stone");
require("Blood");

offsetX = 0;
offsetY = 0;

shakeEnd = 0;
shakeMagnitude = 3;
shakeScale = 15;

function shake(duration, magnitude, scale)
    shakeEnd = love.timer.getTime() / 1000 + duration;
    shakeMagnitude = magnitude;
    shakeScale = scale;
end

local timers = {};
function timer(delay, cb)
    table.insert(timers, {love.timer.getTime() / 1000 + delay, cb});
end

function play()
    game:setVisible(true);
    mainmenu:setVisible(false);
    game:play();
end

function quit()
    game:setVisible(false);
    mainmenu:setVisible(true);
    game:quit();
end

function love.load()
    mainmenu = MainMenu:new();
    game = Game:new();
    game:setVisible(false);
    love.keyboard.setKeyRepeat(0.2, 0.05);
end

function love.draw()

    --love.graphics.setColor(255, 255, 255);
    --love.graphics.rectangle("fill", 0, 0, 1000, 1000);

    if (love.timer.getTime() / 1000 < shakeEnd) then
        offsetX = math.cos(math.sin(love.timer.getTime() / 1000 * 5) * shakeScale) * shakeMagnitude;
        offsetY = math.sin(math.cos(love.timer.getTime() / 1000 * 5) * shakeScale) * shakeMagnitude;
    else
        offsetX = 0;
        offsetY = 0;
    end

    for _, panel in pairs(panels) do
        if (panel:isValid()) then
            panel:draw();
        end
    end

    for _, particle in pairs(particles) do
        particle:draw();
    end

end

function love.keypressed(key)
    if (game:isValid()) then
        game:press(key);
    end

    if (key == " " or key == "return") then
        for _, panel in pairs(panels) do
            if panel._enterToPress and panel:isValid() then
                panel:click();
                print(panel.click);
                print(panel._label);
                return;
            end
        end
    end
end

function love.keyreleased(key)
    if (game:isValid()) then
        game:release(key);
    end
end

activepanel = nil

function love.mousepressed(x, y, button)
    if (button == "l") then
        if (activepanel and activepanel:isValid() and activepanel:isHovered()) then
            activepanel:click()
        end
    end
end

function love.mouserelease()
end

function love.mousemove(x, y)
    activepanel = nil
    for k, v in pairs(panels) do
        if (v:isHovered() and v:isValid()) then
            activepanel = v;
            break;
        end
    end
end

local _mx, _my = 0, 0;
function love.update(dt)
    -- local mx, my = love.mouse.getPosition();
    -- if (mx ~= _mx and my ~= _my) then
    --     love.mousemove(mx, my);
    -- end

    local t = 0;
    local time = love.timer.getTime() / 1000;
    while (t < #timers) do
        t = t + 1;
        local timer = timers[t];
        if (timer[1] < time) then
            timer[2]();
            table.remove(timers, t);
            t = t - 1;
        end
    end

    local i = 0;
    while (i < #particles) do
        i = i + 1;
        if (particles[i]._queueDelete) then
            table.remove(particles, i);
            i = i - 1;
        end
    end

    local i = 0;
    while (i < #panels) do
        i = i + 1;
        if (panels[i]._queueDelete) then
            table.remove(panels, i);
            i = i - 1;
        end
    end

    for _, particle in pairs(particles) do
        if (particle._updateInGame and game:canUpdate() or not particle._updateInGame) then
            particle:update(dt);
        end
    end

    for _, panel in pairs(panels) do
        panel:update(dt);
    end

end
