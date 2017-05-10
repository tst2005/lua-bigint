local mul = require "mathsafe".mul
local max = 10

local r = {mul(2, 2, max)}	-- 4
assert(r[2]==0 and r[1]==4)	-- 4

local r = {mul(2, 5, max)}	-- 10
assert(r[2]==1, r[1]==0)	-- 1 0

local r = {mul(2, 6, max)}	-- 12
assert(r[2]==1, r[1]==2)	-- 1 2

local r = {mul(9, 9, max)}	-- 81
assert(r[2]==8, r[1]==1)	-- 8 1

local max = 10000
local r = {mul(100, 20, max)}      -- 998001
print(require"tprint"(r))



--[[
local r = {mul(99, 99, max)}	-- 99+99=198
assert(r[2]%max==9 and r[1]%max==8)	-- = _ 9 8

local r = {mul(99, 99%max, max)}    -- 99+9=108
assert(r[2]==10 and r[1]%max==8) -- = 10 8
]]--
