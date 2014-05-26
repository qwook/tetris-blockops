
class "Vein" extends "Particle"

function Vein:init()
    self.super:init();
    self._duration = 0.25;
    self._control = Vector(math.random(-20, 20), math.random( -10, 10 ));
    print(self._control.y);

    self._done = false
end

function Vein:update(dt)
    self.super:update(dt);

    if (self:getLifeTime() > self._duration * 10) then
        --self:delete();
        if (not self._done) then
            for i = 1, 2 do
                local vein = Vein:new();
                vein:setOrigin(self:getEnd());
                vein:setEnd(self:getEnd() + Vector(math.random(-40, 40), math.random( -20, -10)));
            end
        end
        self._done = true;
    end
end

function Vein:draw()
    local startpos = self:getOrigin();
    local endpos = self:getEnd();

    local p = self:getLifeTime() / self._duration;

    love.graphics.setColor(255, 0, 0);

    for i = 0, 10 do
        local t = math.min(math.max(p - i, 0), 1);

        local controlpos = startpos + ((endpos - startpos) / 2) + self._control

        local a = startpos:lerp(controlpos, i/10);
        local b = controlpos:lerp(endpos, i/10);
        local c = a:lerp(b, i/10);

        local d = startpos:lerp(controlpos, i/10 + t/10);
        local e = controlpos:lerp(endpos, i/10 + t/10);
        local f = d:lerp(e, i/10 + t/10);

        --love.graphics.setLineWidth(math.max((10-i) * (p/20), 1));

        love.graphics.line(
            c.x,
            c.y, 
            f.x,
            f.y
        );
    end

    love.graphics.setLineWidth(1);

end

