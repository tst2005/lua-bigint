local class = require "mini.class"
local instance = assert(class.instance)

local bigint = class("bigint", {})

function bigint:init(v, parentconfig)
	--print("init:", v, type(parentconfig))
	parentconfig = type(parentconfig) ~= "table" and {} or parentconfig
	--self.name = "bigint"
	self.base = parentconfig.base or 10
	self.size = parentconfig.size or 9 -- precision base^size should be less than the native max integer value (signed int: 2^31-1 or 2^63-1) : approx 2*10^9 or 9*10^18
	if v then
		self:fromstring(v, 10)
	end
	require"mini.class.autometa"(self, bigint) -- copy all __* bigint methods into the metatable of the instance
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
	assert(v:find("^[0-9]+$"), "invalid format must be strickly [0-9]+")
	local r = {}
	local size = self.size
	while #v > 0 do
		local x = tonumber(v:sub(-size, -1))
		v=v:sub(1,-1-size)
		r[#r+1] = x
	end
	return r
end

function bigint:tostring()
	assert(self.v)
	local r = {}
	local t = self.v

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
-- a way to estimate the approximative size of the number (10^n)
function bigint:how()
	return ((#self.v -1) * self.size + #tostring(self.v[#self.v]))
end

function bigint:add(mores)
	if type(mores) == "number" then
		mores = ("%.0f"):format(mores)
	end
	if type(mores)=="string" then
		mores = instance(bigint, mores, self)
		assert(mores.size == self.size)
	end
	assert(type(mores)=="table" and mores.name=="bigint", "argument #1 must be a bigint")
--	assert(type(n)=="number")
--	assert(n>=0)
	local max = (self.base ^ self.size)
	local floor = math.floor
	local function safeadd(cur, incr, max)
		return
			--abs( max - incr%max - cur) - max,
			(max-cur > incr%max) and (cur+incr%max) or ((incr%max) - (max - cur)), -- over: ce qui depasse]]
			floor( cur / max + (incr)%max / max ) -- rest: multiple de max
	end
	local incrs = mores.v
	local more = nil
	local r = {}
	--if #mores.v > #self.v then print("WORKAROUND") return mores:add(self) end
	--for i, v in ipairs(self.v) do
	for i=1,math.max(#self.v, #incrs) do local v = self.v[i]
		local new = v
		if more and more ~=0 or incrs[i] then
			more = (more or 0) + (incrs[i] or 0)%max
		end
		if v and more then --and more ~= 0 then
		--	local lastmore = more
			new, more = safeadd(v%max, more%max, max)
		--	print(i, "safeadd:", v, lastmore, "=>", new, more, "max", max)
		end
		if new then
			r[i] = new
		end
	end
	if more then
		r[#r+1] = more
	end
	self.v = r
	return self
end

--bigint.__add = function(...) print("__add", ...) return bigint.add(...) end
bigint.__add = bigint.add
--bigint.__mul = bigint.mul
bigint.__tostring = bigint.tostring

local M = {}
setmetatable(M, {__call = function(_, ...) return instance(bigint, ...) end})
return M
