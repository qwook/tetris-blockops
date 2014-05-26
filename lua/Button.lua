
class "Button" extends "GUI"

function Button:init()
    self.super:init()

    self._enterToPress = false;
    self._label = "";
    self._cb = nil;
end

function Button:setLabel(label)
    self._label = label;
end

function Button:setCallback(cb)
    self._cb = cb;
end

function Button:click()
    if self._cb then
        self._cb();
    end
end

function Button:draw()
    if self:isHovered() then
        love.graphics.setColor(100, 100, 100, 255);
    else
        love.graphics.setColor(90, 90, 90, 255);
    end

    love.graphics.rectangle("fill", self._origin.x, self._origin.y, self._width, self._height);

    love.graphics.setFont(font);
    love.graphics.setColor(255, 255, 255);
    love.graphics.printf(self._label, 0, self._origin.y + self._height / 2 - 10, self._width, "center");
end