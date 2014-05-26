
class "MainMenu" extends "GUI"

local startMenuSprite = love.graphics.newImage("images/startmenu.png");
local startSprite = love.graphics.newImage("images/startbutton.png");

function MainMenu:init()
    self.super:init()
    self._playButton = Button:new();
    self._playButton:setLabel("Play");
    self._playButton:setSize(640, 480);
    self._playButton:setCallback(function()
        play();
    end)
    self._playButton._enterToPress = true;
    self._playButton.draw = function(self)
        love.graphics.setColor(255, 255, 255);
        love.graphics.draw(startMenuSprite, 0, 0);

        love.graphics.setColor(255, 255, 255, 127 + math.sin(love.timer.getTime() / 1000 * 6) * 100);
        love.graphics.draw(startSprite, 325, 370);
    end
end

function MainMenu:setVisible(visi)
    self.super:setVisible(visi);

    self._playButton:setVisible(visi);
end