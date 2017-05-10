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
--[[
local function table_reverse(t)
	local r = {}
	local max = #t
	for i=1,max do
		r[max-i+1] = t[i]
	end
	return r
end
]]--
--print(require"tprint"( table_reverse({1,2,3})))

function bigint:tostring()
	assert(self.v)
	local r = {}
	local t = self.v
--	for i,v in ipairs(self.v) do

	--print("before clean #t :", #t)
	-- clean all first segment equal to 0
	for i=#t,1,-1 do
		if t[i]==0 then
			--print(i, t[i], "equal to 0, remove!")
			t[i]=nil
		else
			--print(i, t[i], "not equal to 0, break")
			break
		end
	end
	--print("after clean #t :", #t)
	for i=#t,1,-1 do
		local v = t[i]
		local x = ("%.0f"):format(v)
		if i ~= #t then
			x = (("0"):rep(self.size-#x))..x
		end
		--print("+", i, x)
		r[#r+1] = x
	end
	return table.concat(r, self.sep or "")
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
	local more = nil --mores[1] --%max
	local r = {}
	for i, v in ipairs(self.v) do
		local new = v
		if more and more ~=0 or mores[i] then
			more = (more or 0) + (mores[i] or 0)%max
		end
		if more and more ~= 0 then
			local lastmore = more
			new, more = safeadd(v, more)
		--	print(i, "safeadd:", v, lastmore, "=>", new, more, "max", max)
		end
		r[i] = new
	end
	if more then
		r[#r+1] = more
	end
	self.v = r
	return self
end

function bigint:how()
	return ((#self.v -1) * self.size + #tostring(self.v[#self.v]))
end

local M = {}
setmetatable(M, {__call = function(_, ...) return instance(bigint, ...) end})
return M
