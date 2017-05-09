local bigint = require "bigint"

local x
local src

--print(require"tprint"( (bigint("1234567890").v))) -- {890,567,234,1,}

--[[

x = bigint("123456789012345678901234567890")
assert(type(x) == "table")
assert(x:tostring() == "123456789012345678901234567890")

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

src = "123456789012345678901234567890123456789012345678901234"
src = "99991234"
local a = "99991234"

local tprint = require"tprint"
tprint.ishort = false

local x0 = bigint()
x0.size = 4
x0.sep = " "
x0:fromstring(src, 10)

local a0 = bigint()
a0.size = 4
a0.sep = " "
a0:fromstring(a, 10)
print(tprint( a0.v))

x = bigint()
x.size = 4
x.sep = " "
x:fromstring(src, 10)

print(tprint( x.v))


print("add", a)

x:add(a0.v)

print(src)
print(x0:tostring())
print(x:tostring())

print(tprint( x0.v))
print(tprint( x.v))

--print(#x.v, x.size, #tostring(x.v[#x.v]))
print("estimate: ~10^"..(#x.v -1) * x.size + #tostring(x.v[#x.v]))

