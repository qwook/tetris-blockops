
class "Pause" extends "GUI"

function Pause:init()
    self.super:init()

    local _self = self;

    self._resumeButton = Button:new();
    self._resumeButton._enterToPress = true;
    self._resumeButton:setLabel("Resume");
    self._resumeButton:setSize(200, 100);
    self._resumeButton:setCallback(function()
        _self:setVisible(false);
    end)

    self._quitButton = Button:new();
    self._quitButton:setLabel("Quit");
    self._quitButton:setOrigin(Vector( 0, 120 ));
    self._quitButton:setSize(200, 100);
    self._quitButton:setCallback(function()
        quit();
    end)
end

function Pause:setVisible(visi)
    self.super:setVisible(visi);

    self._resumeButton:setVisible(visi);
    self._quitButton:setVisible(visi);
end

function Pause:draw()
    love.graphics.setColor(0, 0, 0, 50);
    love.graphics.rectangle("fill", 0, 0, 640, 480)

    love.graphics.setFont(font);
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Pause", 300, 200)
end
