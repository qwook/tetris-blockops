
--[[

    The MIT License (MIT)

    Copyright (c) 2013 Henry Q. Tran

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

    Lua class system written by Henry Q. Tran
    qwook.github.com / visidyn.com

    Usage:

    
        class "Hi"

        function Hi:init(poop)
            self.blah = poop
        end

        function Hi:print()
            print("Eat: " .. self.blah);
        end

        class "Hello" extends "Hi"

        function Hello:print()
            print(self.blah);
            self.super:print();
        end


--]]

local lastClass;
local lastClassName;
local _R = {};
local super = {
    __index = function(this, key)
        local value = this.mt[key];
        if type(value) == "function" then
            return function (self, ...)
                return value(this.obj, ...);
            end
        else
            return value;
        end
    end
};

function extends( _parentClassName )
    local class = lastClass;
    if (class and _G[_parentClassName]) then
        class.__olindex = class.__index;
        class.__super = _G[_parentClassName];
        class.__index = function(self, key)
            if (not class.__olindex[key]) then
                return class.__super[key];
            end

            return class.__olindex[key];
        end
    end
end

function class( _className )
    lastClassName = _className;
    local mt = {};
    _G[_className] = {new = function(...)
        local obj = {};
        setmetatable(obj, mt);
        if (mt.__super) then
            obj.super = {obj = obj, mt = mt.__super};
            setmetatable(obj.super, super);
        end
        obj.getClassName = function()
            return _className;
        end
        if (obj["init"]) then
            obj["init"](obj, unpack({...}, 2));
        end
        return obj;
    end};
    mt.__index = _G[_className];
    mt.__className = _className;
    _G[_className].mt = mt;
    lastClass = mt;
end
