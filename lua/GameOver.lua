
class "GameOver" extends "GUI"

local font = love.graphics.newFont(14)

function GameOver:init()
    self.super:init();
    self._playButton = Button:new();
    self._playButton._enterToPress = true;
    self._playButton:setLabel("Play Again");
    self._playButton:setSize(200, 100);
    self._playButton:setCallback(function()
        play();
    end)

    self._quitButton = Button:new();
    self._quitButton:setLabel("Quit");
    self._quitButton:setOrigin(Vector( 0, 120 ));
    self._quitButton:setSize(200, 100);
    self._quitButton:setCallback(function()
        quit();
    end)
end

function GameOver:setVisible(visi)
    self.super:setVisible(visi);

    self._playButton:setVisible(visi);
    self._quitButton:setVisible(visi);
end

function GameOver:draw()
    love.graphics.setColor(0, 0, 0, 50);
    love.graphics.rectangle("fill", 0, 0, 640, 480)

    love.graphics.setFont(font);
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Game Over", 300, 200)
end
