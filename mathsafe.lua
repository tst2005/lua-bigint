


local floor = math.floor

local function safe_add(cur, incr, max)
	return
		(max-cur > incr) and (cur+incr) or ((incr) - (max - cur)), -- over: ce qui depasse]]
		floor( cur / max + incr / max ) -- rest: multiple de max
end

-- condition:
--   (a*b)     < max
--   (a*b)/max < 1
--   (a*b/max)/max < 1/max
--   (a/max)*(b/max) < 1/max

local function safe_mul(a, b, max)
	assert(a>=0)
	assert(b>=0)
	assert(max>=2)

	if (a/max)*(b/max) < (1/max) then
		return a*b, 0
	end
	local xx = (a/max)*(b/max) -- 0..<1 (0.81 pour max=10)
	local y = floor(xx*max) -- 0..<max (floor(8.1) = 8 pour max=10)
	local x = ( (a/max)*(b/max) - (y/max) ) *max
	return x, y
end

-- x:
--	(a*b)%max
--	((a/max*b)*max)%max

-- y:
--	(a*b)//max
--	floor((a*b)/max)
--	floor(a/max*b)



return {
	add = safe_add,
	mul = safe_mul,
}
