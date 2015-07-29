local class = require "slither"

class "Food" {
	eaten = false,

	__init__ = function(self, name)
		self.name = name
		print(("Delicious %s created!"):format(name))
	end,

	eat = function(self)
		if self.eaten then
			print("You bite in nothing, it hurts your teeth.")
		else
			print(("The %s has been eaten :("):format(self.name))
			self.eaten = true
		end
	end,

	__add__ = function(self, other)
		if type(other) == "table" and other.__class__ == self.__class__ then
			print("You smash the food together and create:")
			return self.__class__(("%s-y %s"):format(other.name, self.name))
		end
	end
}

foods = {}

-- Old-style inheritence
class "foods.Cake" ("Food") {
	eat = function(self)
		print("LIES!")
	end
}

-- New-style inheritence
class "foods.Candy" (Food) {
	eat = function(self)
		print("The dentist frowns upon your actions!")
	end
}

banana = Food("banana")
chocolate = Food("chocolate")
portal_cake = foods.Cake("Portal Cake")
sugary_candy = foods.Candy("Sugary Candy")

banana:eat()
portal_cake:eat()
sugary_candy:eat()

chocolate_banana = banana + chocolate
chocolate_banana:eat()

assert(class.isinstance(chocolate_banana, Food) and class.isinstance(portal_cake, Food) and class.issubclass(foods.Cake, Food) and class.issubclass(foods.Cake, foods.Cake) and not class.issubclass(Food, foods.Cake), "Inheritance checking is wrong")

Override = class.Override

class "Debugged" (class.Annotation)
{
	apply = function(self, f, name, class, counter)
		if counter then
			counter.step = counter.step + 1
			return f
		end

		counter = { count = 0, step = 1 }
		return function(...)
			print("Function " .. class.__name__ .. "." .. name .. " called with " .. select('#', ...) .. " arguments")
			counter.count = counter.count + counter.step
			return f(...)
		end, counter
	end,
}

class "Iterator" (class.Annotation)
{
	apply = function(self, f, name, class)
		local function wrapper(...)
			coroutine.yield()
			return f(...)
		end
		return function(...)
			local co = coroutine.wrap(wrapper)
			co(...)
			return co
		end
	end,
}

class "Serialize" (class.Annotation)
{
	apply = function(self, f, name, class)
		return f, true
	end,

	format = function(data)
		return tostring(data)
	end,
}

class "SerializeHex" (Serialize)
{
	format = function(data)
		return ("%x"):format(data)
	end,
}

class "SerializedName" (class.Annotation)
{
	applyClassPre = function(self, name, prototype)
		prototype.name = Serialize() + name
	end,
}

class "AddSerializer" (class.Annotation)
{
	applyClassPost = function(self, name, class)
		function class:serialize()
			print("Serializing " .. name)
			for ann, member in Serialize:iterateFull(class) do
				print("    " .. member .. " = " .. ann.format(self[member]))
			end
		end
	end,
}

class "Test"
{
	test = Serialize() + function()
	end,

	inherited = Serialize() + "Yes, definitely!",
}

class "TestChild" (Test)
{
	-SerializedName(),
	-AddSerializer(),

	test = Debugged() + Override() +
	function()
	end,

	testb = Debugged() + Debugged() + function() end,

	-- Definition below errors because it does not override anything
	--testc = Override() + function() end,

	count = Iterator() +
	function(self, start, stop)
		for i = start, stop do
			coroutine.yield(i)
		end
	end,

	storage = Serialize() + 0,
	hexStorage = SerializeHex() + 0,
}

t = TestChild()
t:test(1)
t:testb()

for member, counter in Debugged:iterate(TestChild) do
	print("Class member " .. member .. " called " .. counter.count .. " times")
end

for num in t:count(5, 8) do
	print("Count", num)
end

t:serialize()
t.storage = 15
t.hexStorage = 18
t:serialize()
