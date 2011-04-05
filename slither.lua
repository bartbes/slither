--[[ zlib license:
Copyright (c) 2011 Bart van Strien

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
  claim that you wrote the original software. If you use this software
  in a product, an acknowledgment in the product documentation would be
  appreciated but is not required.

  2. Altered source versions must be plainly marked as such, and must not be
  misrepresented as being the original software.

  3. This notice may not be removed or altered from any source
  distribution.
]]

local function class_generator(name, b, t)
	local temp = {}
	_G[name] = setmetatable(temp, {
		__index = function(self, key)
			if key == "__class__" then return temp end
			if key == "__name__" then return name end
			if t[key] then return t[key] end
			for i, v in ipairs(b) do
				if v[key] then return v[key] end
			end
		end,
		__newindex = function(self, key, value)
			t[key] = value
		end,
		__call = function(self, ...)
			local smt = getmetatable(self)
			local mt = {__index = smt.__index}
			if self.__cmp__ then
				if not smt.eq or not smt.lt then
					function smt.eq(a, b)
						return a.__cmp__(a, b) == 0
					end
					function smt.lt(a, b)
						return a.__cmp__(a, b) < 0
					end
				end
				mt.__eq = smt.eq
				mt.__lt = smt.lt
			end
			for i, v in pairs{
				__call__ = "__call", __len__ = "__len",
				__add__ = "__add", __sub__ = "__sub",
				__mul__ = "__mul", __div__ = "__div",
				__mod__ = "__mod", __pow__ = "__pow",
				__neg__ = "__unm"
				} do
				if self[i] then mt[v] = self[i] end
			end
			local instance = setmetatable({}, mt)
			if instance.__init__ then instance:__init__(...) end
			return instance
		end
		})
end

local function inheritance_handler(name, ...)
	local args = {...}
	if #args == 1 and type(args[1]) == "table" then
		return class_generator(name, {}, args[1])
	end
	for i, v in ipairs(args) do
		args[i] = _G[v]
	end
	return function(t)
		return class_generator(name, args, t)
	end
end

function class(name)
	return function(...)
		return inheritance_handler(name, ...)
	end
end
