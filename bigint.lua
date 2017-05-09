local class = require "mini.class"
local instance = assert(class.instance)

local bigint = class("bigint", {})

function bigint:init(v)
	self.base = 10
	self.size = 3
	if v then
		self.v = self:fromstring(v, 10)
		self.strv = v
	end
end

function bigint:fromstring(v, base)
	if base == 10 then
		return self:b10fromstring(v)
	end
	error("invalid base")
end

function bigint:b10fromstring(v)
	assert(type(v)=="string")
	assert(not v:find("^[0-9+]$"), "invalid format must be strickly [0-9]+")
	local r = {}
	local size = self.size
	while #v > 0 do
		local x = v:sub(-size, -1)
		v=v:sub(1,-1-size)
		r[#r+1] = x
	end
	return r
end
local function table_reverse(t)
	local r = {}
	local max = #t
	for i=1,max do
		r[max-i+1] = t[i]
	end
	return r
end
--print(require"tprint"( table_reverse({1,2,3})))

function bigint:tostring()
	assert(self.v)
	local r = {}
	for _i,v in ipairs(self.v) do
		local x = ("%.0f"):format(v)
		if _i ~= 1 then
			x = (("0"):rep(self.size-#x))..x
		end
		r[#r+1] = x
	end
	return table.concat(table_reverse(r), "")
end
local M = {}
setmetatable(M, {__call = function(_, ...) return instance(bigint, ...) end})
return M
