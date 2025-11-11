print("Advent of neovim")

local number = 4
local string = "hello, world!"

local function hello(name)
	print("Hello!", name)
end

hello("Bruno")

local higher_order = function(num)
	return function(other)
		return num + other
	end
end

local add_one = higher_order(1)

print(add_one(10))

print("Lua has one data structure")
print("Tables are like lists or maps")
print("Tables are heterogeneous")

print("As a list:")
local list = { "first", 2, false }
print(list)
print(list[1])

print("As a map:")
local map = {
	k = "v",
	["an expression"] = "works"
}
print(map)
print(map["k"])
print(map["an expression"])

print("For loops")
local cars = { "toyota", "nissan", "ford", "chevy", "honda" }
for index = 1, #cars do
	print(index, cars[index])
end

print("Use `ipairs` (integer pairs) to iterate over lists")
for index, value in ipairs(cars) do
	print(index, value)
end

print("Use `pairs` to iterate over maps")
for k, v in pairs(map) do
	print(k, v)
end


local function action(loves_coffee)
	if loves_coffee then
		print("DRINK")
	else
		print("Don't drink!")
	end
end

print(true, action(true))
print(nil, action(nil))
print(false, action(false))

require("bar")


local setup = function(opts)
	if opts.default == nil then
		opts.default = 17
	end
	print(opts.default, opts.other)
end

setup { default = 12, other = "other" }
setup {}


print("Colon functions")
local MyTable = {
	k = "value",
	a = 1
}
function MyTable.something1() 
	print("SOMETHING")
end
function MyTable:something( ... ) 
	print("I AM A METHOD")
	for k, v in pairs(self) do
		print(k, v)
	end
end


print("Meta tables")

MyTable.something1()
MyTable:something()

print("Metatables")

local vector_mt = {}
vector_mt.__add = function(left, right)
	return setmetatable({
		left[1] + right[1],
		left[2] + right[2],
		left[3] + right[3],
	}, vector_mt)
end

local v1 = setmetatable({ 3, 1, 5 }, vector_mt)
local v2 = setmetatable({ -3, 2, 5 }, vector_mt)
local v3 = v1 + v2
for k, v in pairs(v3) do
	print(k, v)
end

