Test("Existance of class keyword", function()
	assert(class)
end)

Test("Existance of issubclass function", function()
	assert(issubclass)
end)

Test("Existance of isinstance function", function()
	assert(isinstance)
end)

Test("Creating a class", function()
	class "Test" {}
end)

Test("Instantiating", function()
	class "Test" {}
	Test()
end)

Test("Accessing attributes", function()
	class "Test" {
		attribute = true
	}
	assert(Test().attribute)
end)

Test("Calling methods", function()
	class "Test" {
		method = function() return true end
	}
	assert(Test():method())
end)

Test("Methods get correct self", function()
	class "Test" {
		method = function(self) return self end
	}
	t = Test()
	assert(t:method() == t)
end)

Test("Inheritance syntax", function()
	class "TestBase" {}
	class "Base" ("TestBase") {}
end)

Test("Attribute inheritance", function()
	class "TestBase" {
		attribute = true
	}
	class "Test" ("TestBase") {}
	assert(Test().attribute)
end)

Test("Method inheritance", function()
	class "TestBase" {
		method = function() return true end
	}
	class "Test" ("TestBase") {}
	assert(Test():method())
end)

Test("Correct self with method inheritance", function()
	class "TestBase" {
		method = function(self) return self end
	}
	class "Test" ("TestBase") {}
	t = Test()
	assert(t:method() == t)
end)

Test("Multiple inheritance", function()
	class "TestBase1" {
		a = true
	}
	class "TestBase2" {
		b = true
	}
	class "Test" ("TestBase1", "TestBase2") {}
	t = Test()
	assert(t.a)
	assert(t.b)
end)

Test("Multiple inheritance preference rules", function()
	class "TestBase1" {
		a = 1
	}
	class "TestBase2" {
		a = 2
	}
	class "Test" ("TestBase1", "TestBase2") {}
	assert(Test().a == 1)
end)

Test("Correct issubclass indication", function()
	class "TestBase1" {}
	class "TestBase2" {}
	class "TestBase3" {}
	class "TestBase4" ("TestBase3") {}
	class "TestBase5" {}
	class "Test" ("TestBase1", "TestBase2", "TestBase4") {}
	-- TestBase5 is NOT a parent,
	-- TestBase3 IS a parent (though indirectly).
	assert(issubclass(Test, TestBase1))
	assert(issubclass(Test, TestBase2))
	assert(issubclass(Test, TestBase3))
	assert(issubclass(Test, TestBase4))
	assert(not issubclass(Test, TestBase5))
	assert(issubclass(Test, {TestBase1, TestBase3}))
	assert(issubclass(TestBase4, TestBase3))
end)

Test("Correct isinstance indication", function()
	class "TestBase1" {}
	class "TestBase2" {}
	class "Test" ("TestBase1") {}
	-- TestBase2 is NOT a parent.
	t = Test()
	tb2 = TestBase2()
	assert(isinstance(t, Test))
	assert(isinstance(t, TestBase1))
	assert(not isinstance(t, TestBase2))
	assert(not isinstance(tb2, Test))
end)

Test("__class__ referring to class of object", function()
	class "Test" {}
	assert(Test().__class__ == Test)
end)

Test("__name__ referring to object's class name", function()
	class "Test" {}
	assert(Test().__name__ == "Test")
end)

Test("__call__ on calling object", function()
	class "Test" {
		__call__ = function() return 1 end
	}
	assert(Test()() == 1)
end)

Test("__add__ on addition", function()
	class "Test" {
		__add__ = function() return 1 end
	}
	assert(Test() + Test() == 1)
end)

Test("__sub__ on subtraction", function()
	class "Test" {
		__sub__ = function() return 1 end
	}
	assert(Test() - Test() == 1)
end)

Test("__mul__ on multiplication", function()
	class "Test" {
		__mul__ = function() return 1 end
	}
	assert(Test() * Test() == 1)
end)

Test("__div__ on division", function()
	class "Test" {
		__div__ = function() return 1 end
	}
	assert(Test() / Test() == 1)
end)

Test("__mod__ on modulus", function()
	class "Test" {
		__mod__ = function() return 1 end
	}
	assert(Test() % Test() == 1)
end)

Test("__pow__ on power", function()
	class "Test" {
		__pow__ = function() return 1 end
	}
	assert(Test() ^ Test() == 1)
end)

Test("__neg__ on negation", function()
	class "Test" {
		__neg__ = function() return 1 end
	}
	assert(-Test() == 1)
end)

Test("__cmp__ on comparison", function()
	local mode
	class "Test" {
		__cmp__ = function() return mode end
	}
	--mode 0, equal
	mode = 0
	assert(Test() == Test())
	--mode >0, greater than or equal
	mode = 1
	assert(Test() >= Test())
	--mode <0, less than
	mode = -1
	assert(Test() < Test())
end)

Test("__getattr__ on non-existant lookups", function()
	class "Test" {
		__getattr__ = function(self, key)
			return key == "a"
		end
	}
	t = Test()
	assert(t.a)
	assert(not t.b)
end)

Test("__setattr__ on non-existant writes", function()
	local called = false
	local same = false
	class "Test" {
		__setattr__ = function(self, key, value)
			called = true
			same = key == value
		end
	}
	t = Test()
	t.a = "a"
	assert(called)
	assert(same)
	t.a = "b"
	assert(not same)
end)

Test("No leaking internal functions/variables", function()
	assert(not stringtotable)
	assert(not class_generator)
	assert(not inheritance_handler)
end)

Test("New-style inheritence", function()
	class "TestBase" {
		some_var = true,
		some_method = function(self) return self.some_var end,
	}
	class "Test" (TestBase) {
	}
	t = Test()
	assert(t.some_var)
	assert(t:some_method())
end)

Test("Returning of class", function()
	test = class "Test" {
	}
	assert(test == Test)
end)

Test("Private class definition", function()
	local test = class.private "TestClass" {
	}
	assert(TestClass == nil)
	assert(test)
end)
