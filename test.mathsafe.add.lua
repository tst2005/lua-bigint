local add = require "mathsafe".add
local max = 10

local r = {add(4, 5, max)}	-- 9
assert(r[2]==0 and r[1]==9)	-- 9

local r = {add(9, 9, max)}	-- 18
assert(r[2]==1 and r[1]==8)	-- 18

local r = {add(99, 99, max)}	-- 99+99=198
assert(r[2]%max==9 and r[1]%max==8)	-- = _ 9 8

local r = {add(99, 99%max, max)}    -- 99+9=108
assert(r[2]==10 and r[1]%max==8) -- = 10 8

