local class = require "mini.class"
local instance = assert(class.instance)

local bigint = class("bigint", {})

function bigint:init(v)
	self.base = 10
	self.size = 3
	if v then
		self:fromstring(v, 10)
		--self.strv = v
	end
end

function bigint:fromstring(v, base)
	if base == 10 then
		self.v = self:_base10_fromstring(v)
		return self.v
	end
	error("invalid base")
end

function bigint:_base10_fromstring(v)
	assert(type(v)=="string")
	assert(not v:find("^[0-9+]$"), "invalid format must be strickly [0-9]+")
	local r = {}
	local size = self.size
	while #v > 0 do
		local x = tonumber(v:sub(-size, -1))
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
	local max = #self.v
	for _i,v in ipairs(self.v) do
		local x = ("%.0f"):format(v)
		if _i ~= max then
			x = (("0"):rep(self.size-#x))..x
		end
		r[#r+1] = x
	end
	return table.concat(table_reverse(r), self.sep or "")
end

function bigint:add(mores)
--	assert(type(n)=="number")
	--assert(math.type(n)=="integer")
--	assert(n>=0)
	local max = (self.base ^ self.size)
	local floor = math.floor
	local abs = math.abs
	local min = math.min
	local function safeadd(cur, incr)
		return
			--abs( max - incr%max - cur) - max,
			(max-cur >= incr%max) and cur+incr%max or ((incr%max) - (max - cur)), -- over: ce qui depasse]]
			floor( cur / max + (incr)%max / max ) -- rest: multiple de max
	end
	local more = 0 --mores[1] --%max
	local r = {}
	for i, v in ipairs(self.v) do
		local new = v
		more = (more or 0) + ( mores[i] or 0)%max
		if more and more ~= 0 then
			local lastmore = more
			new, more = safeadd(v, more)
			print(i, "safeadd:", v, lastmore, "=>", new, more, "max", max)
		end
		r[i] = new
	end
	if more then
		r[#r+1] = more
	end
	self.v = r
	return self
end

local M = {}
setmetatable(M, {__call = function(_, ...) return instance(bigint, ...) end})
return M
