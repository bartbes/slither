class = require "slither"

local tests = {}
local env_mt = {__index = _G}

class "Test" {
	__init__ = function(self, name, func)
		assert(name, "Test needs a name")
		self.name = name
		if func then
			self.func = func
		end
		self.success = nil
		self.err = nil
		table.insert(tests, self)
	end,

	func = function() end,

	run = function(self)
		setfenv(self.func, setmetatable({}, env_mt))
		self.success, self.err = pcall(self.func, self)
		return self.success
	end
}

-- actually load the tests

require "tests"

-- and do our main

function main(...)
	assert(#tests > 0, "Need tests!")

	--read and parse arguments
	local args = {...}
	local flags = {}
	for i, v in ipairs(args) do
		flags[v] = true
	end
	args = nil

	local failed = 0

	for i, v in ipairs(tests) do
		io.write(v.name .. ": WORKING")
		io.stdout:flush()
		if not v:run() then
			print("\r" .. v.name .. ": FAIL: " .. v.err)
			failed = failed + 1
		else
			print("\r" .. v.name .. ": SUCCESS")
		end
	end

	print()
	print("SUMMARY")
	print(("  Failed: %d/%d"):format(failed, #tests))
	print(("  Success rate: %.0d%%"):format(100*(1-failed/#tests)))
end

main(...)
