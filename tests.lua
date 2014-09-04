Test("Existence of class keyword", function()
	assert(class)
end)

Test("Existence of issubclass function", function()
	assert(class.issubclass)
end)

Test("Existence of isinstance function", function()
	assert(class.isinstance)
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
	assert(class.issubclass(Test, TestBase1))
	assert(class.issubclass(Test, TestBase2))
	assert(class.issubclass(Test, TestBase3))
	assert(class.issubclass(Test, TestBase4))
	assert(not class.issubclass(Test, TestBase5))
	assert(class.issubclass(Test, {TestBase1, TestBase3}))
	assert(class.issubclass(TestBase4, TestBase3))
end)

Test("Correct isinstance indication", function()
	class "TestBase1" {}
	class "TestBase2" {}
	class "Test" ("TestBase1") {}
	-- TestBase2 is NOT a parent.
	t = Test()
	tb2 = TestBase2()
	assert(class.isinstance(t, Test))
	assert(class.isinstance(t, TestBase1))
	assert(not class.isinstance(t, TestBase2))
	assert(not class.isinstance(tb2, Test))
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

Test("__getattr__ not getting other __*__", function()
	class "Test" {
		__getattr__ = function()
			error("__getattr__ reached")
		end,
	}
	-- __getattr__ used to get called on __*__
	-- in init in the past, make sure it's fixed
	Test()
end)

Test("Number indexes and __*__ getattr prevention", function()
	class "Test"
	{
		__getattr__ = function(self, key)
			if type(key) == "string" then
				error("__getattr__ reached on __*__")
			end
			return true
		end,
	}

	test = Test()
	assert(test[1])
	assert(not test["__init__"])
end)

Test("Deep inheritance", function()
	class "A"
	{
		test1 = true,
		test2 = function() return true end
	}

	class "B" (A) {}
	class "C" (B) {}
	class "D" (C) {}

	d = D()
	assert(d.test1)
	assert(d.test2())
end)

Test("Double (indirect) inheritance", function()
	class "A"
	{
		test1 = true,
		test2 = function() return true end
	}

	class "B" (A) {}
	class "C" (B, A) {}

	c = C()
	assert(c.test1)
	assert(c.test2())
end)

Test("Error on non-existent parent", function()
	local parent = nil
	local success, cont = pcall(class "A", parent)
	assert(not success, "Did not error!")
end)

Test("Resolving false, non-nil values", function()
	class "A"
	{
		test = false
	}

	assert(A.test == false)
end)

Test("Attributes get called", function()
	local called = false

	local function attr(class)
		called = true
	end

	class "A"
	{
		__attributes__ = {attr}
	}

	assert(called)
end)

Test("Attribute can modify class", function()
	local function attr(class)
		class.cake = true
	end

	class "A"
	{
		__attributes__ = {attr}
	}

	assert(A.cake)
end)

Test("Attribute can modify constructor", function()
	local called = false

	local function attr(class)
		local oldinit = class.__init__ or function() end
		class.__init__ = function(...)
			called = true
		end
	end

	class "A"
	{
		__attributes__ = {attr}
	}

	local a = A()
	assert(called)
end)

Test("Attributes are not inherited", function()
	local called = false
	local function attr()
		called = true
	end

	class "A"
	{
		__attributes__ = {attr}
	}

	called = false

	class "B" (A)
	{
	}

	assert(not called)
end)

Test("Attribute can replace return value", function()
	local function attr()
		return "a"
	end

	assert((class "A" { __attributes__ = {attr} }) == "a")
end)

Test("Attributes are called in order", function()
	local function attr1(class)
		class.stage = 1
	end

	local function attr2(class)
		if class.stage == 1 then
			class.stage = 2
		end
	end

	class "A"
	{
		__attributes__ = {attr1, attr2}
	}

	assert(A.stage == 2)
end)

Test("Attributes can be anything callable", function()
	class "Attribute"
	{
		called = false,

		__call__ = function(self)
			self.called = true
		end
	}

	local attr = Attribute()

	class "A"
	{
		__attributes__ = {attr}
	}

	assert(attr.called)
end)

Test("Allocate allocates, but does not call the constructor", function()
	class "A"
	{
		__init__ = function(self)
			self.called = true
		end
	}

	local a = A()
	local b = getmetatable(A).allocate()

	assert(a.called)
	assert(not b.called)
	assert(a.__init__ == b.__init__)
end)

Test("Allocate can allocate 'on' existing tables", function()
	class "A"
	{
		test1 = true
	}

	local a = getmetatable(A).allocate({test2 = true})
	assert(a.test1)
	assert(a.test2)
end)
