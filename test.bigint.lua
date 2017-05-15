local bigint = require "bigint"

local tprint = require"tprint"
tprint.ishort = false

local x
local src

--print( tostring( bigint("1"..("0"):rep(200) ) + bigint("19") ) ) -- == "1"..("0"):rep(200-2).."19")
local comb = {}
for i=1,19 do
	comb[#comb+1] = {base=10, size=i}
end
for _i, cfg in ipairs(comb) do

	local cfg=bigint(nil, cfg)
	do
		local a = bigint("9", cfg)
		local b = bigint("9", cfg)
		assert(a:add(b):tostring() == "18")
	end
	do
		local a = bigint("999", cfg)
		local b = bigint("9", cfg)
		assert(a:add(b):tostring() == "1008")
	end
	do
		local a = bigint("9", cfg)
		local b = bigint("999", cfg)
		local c = a:add(b)
		--print(c:tostring())
		assert(c:tostring() == "1008")
	end

	assert( tostring(bigint("19") + bigint("19"))=="38" )
	assert( tostring( bigint("1"..("0"):rep(200) ) + bigint("19") ) == "100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000019" )
	assert( tostring( bigint("1"..("0"):rep(200) ) + 19 ) == "100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000019" )

end

--[==[

--[[
x=bigint("909", {size=1})
print(tprint(x))
y=bigint("11", x)
print(tprint(y))
x:add(y)
print(tprint(x))
print(x:tostring())
os.exit(0)
]]--
--print(require"tprint"( (bigint("1234567890").v))) -- {890,567,234,1,}

--[[
x = bigint("123456789012345678901234567890")
assert(type(x) == "table")
assert(x:tostring() == "123456789012345678901234567890")
assert(x.name=="bigint")
]]--

--[[
x = bigint( ("123456789012345678901234567890"):rep(5) )
assert(x:tostring()) -- 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
assert("10^"..(#x.v * x.size)) -- 10^150

src = ("9"):rep(300)
x = bigint()
x.size = 8
x:fromstring(src, 10)
assert( (#x.v -1) * x.size + #tostring(x.v[#x.v]) == 300)

src = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234560000"
x = bigint()
--x.sep = " " -- allow to print each group separated by space
x.size = 8
x:fromstring(src, 10)

]]--

--local size = 5
for i, size in ipairs{1,2} do --,3,4,5,6,7,8,9,10} do

local src
local a
local x
src = "123456789012345678901234567890123456789012345678901234"
src = "99991234"
--a = "99991234"
--src = src:rep(10)
a = ("1"):rep(#src-1)
local wanted = "101102345" -- 99991234 + 1111111 = 101102345

local x0 = bigint()
x0.size = size
--x0.sep = " "
x0:fromstring(src, 10)

--[[
local a0 = bigint()
a0.size = size
a0.sep = " "
a0:fromstring(a, 10)
--print(tprint( a0.v))
]]--

x = bigint()
x.size = size
--x.sep = " "
x:fromstring(src, 10)

print(tprint( x.v))

print(src)
print("+ "..a)

x:add(a)

--print(x0:tostring())
--print(x:tostring())

--print(tprint( x0.v))
--print(tprint( x.v))

--print(#x.v, x.size, #tostring(x.v[#x.v]))
--(#x.v -1) * x.size + #tostring(x.v[#x.v]))

print(i, "= "..x:tostring())
local result = x:tostring()
print("estimate: between 10^"..(x:how()-1).." and 10^"..(x:how()))
print(#x.v)
end

]==]--
