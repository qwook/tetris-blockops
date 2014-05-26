
class "GUI"

panels = {};

function GUI:init()
    self._origin = Vector(0, 0);
    self._disabled = false;
    self._visible = true;
    self._queueDelete = false;
    self._width = 0;
    self._height = 0;
    self._hovered = false;
    table.insert(panels, self);
end

function GUI:isHovered()
    return self._hovered;
end

function GUI:isValid()
    return not self._queueDelete and self._visible;
end

function GUI:setOrigin(pos)
    self._origin = pos:copy();
end

function GUI:getOrigin()
    return self._origin:copy();
end

function GUI:setVisible(visi)
    self._visible = visi;
end

function GUI:getVisible(visi)
    return self._visible;
end

function GUI:setSize(width, height)
    self._width = width;
    self._height = height;
end

function GUI:setWidth(width)
    self._width = width;
end

function GUI:setHeight(height)
    self._height = height;
end

function GUI:remove()
    self._queueDelete = true;
end

function GUI:click()
end

function GUI:update(dt)
    -- local x, y = love.mouse.getPosition()
    -- self._hovered = (x > self._origin.x) and (y > self._origin.y) and (x < self._origin.x + self._width) and (y < self._origin.y + self._height)
end

function GUI:draw()
    love.graphics.setColor(255, 40, 40);
    love.graphics.rectangle("fill", self._origin.x, self._origin.y, self._width, self._height);
end
