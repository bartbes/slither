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
	local Test = class "Test" {}
	Test()
end)

Test("Accessing attributes", function()
	local Test = class "Test" {
		attribute = true
	}
	assert(Test().attribute)
end)

Test("Calling methods", function()
	local Test = class "Test" {
		method = function() return true end
	}
	assert(Test():method())
end)

Test("Methods get correct self", function()
	local Test = class "Test" {
		method = function(self) return self end
	}
	t = Test()
	assert(t:method() == t)
end)

Test("Inheritance syntax", function()
	local TestBase = class "TestBase" {}
	local Base = class "Base" (TestBase) {}
end)

Test("Attribute inheritance", function()
	local TestBase = class "TestBase" {
		attribute = true
	}
	local Test = class "Test" (TestBase) {}
	assert(Test().attribute)
end)

Test("Method inheritance", function()
	local TestBase = class "TestBase" {
		method = function() return true end
	}
	local Test = class "Test" (TestBase) {}
	assert(Test():method())
end)

Test("Correct self with method inheritance", function()
	local TestBase = class "TestBase" {
		method = function(self) return self end
	}
	local Test = class "Test" (TestBase) {}
	t = Test()
	assert(t:method() == t)
end)

Test("Multiple inheritance", function()
	local TestBase1 = class "TestBase1" {
		a = true
	}
	local TestBase2 = class "TestBase2" {
		b = true
	}
	local Test = class "Test" (TestBase1, TestBase2) {}
	t = Test()
	assert(t.a)
	assert(t.b)
end)

Test("Multiple inheritance preference rules", function()
	local TestBase1 = class "TestBase1" {
		a = 1
	}
	local TestBase2 = class "TestBase2" {
		a = 2
	}
	local Test = class "Test" (TestBase1, TestBase2) {}
	assert(Test().a == 1)
end)

Test("Correct issubclass indication", function()
	local TestBase1 = class "TestBase1" {}
	local TestBase2 = class "TestBase2" {}
	local TestBase3 = class "TestBase3" {}
	local TestBase4 = class "TestBase4" (TestBase3) {}
	local TestBase5 = class "TestBase5" {}
	local Test = class "Test" (TestBase1, TestBase2, TestBase4) {}
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
	local TestBase1 = class "TestBase1" {}
	local TestBase2 = class "TestBase2" {}
	local Test = class "Test" (TestBase1) {}
	-- TestBase2 is NOT a parent.
	t = Test()
	tb2 = TestBase2()
	assert(class.isinstance(t, Test))
	assert(class.isinstance(t, TestBase1))
	assert(not class.isinstance(t, TestBase2))
	assert(not class.isinstance(tb2, Test))
end)

Test("__class__ referring to class of object", function()
	local Test = class "Test" {}
	assert(Test().__class__ == Test)
end)

Test("__name__ referring to object's class name", function()
	local Test = class "Test" {}
	assert(Test().__name__ == "Test")
end)

Test("__call__ on calling object", function()
	local Test = class "Test" {
		__call__ = function() return 1 end
	}
	assert(Test()() == 1)
end)

Test("__add__ on addition", function()
	local Test = class "Test" {
		__add__ = function() return 1 end
	}
	assert(Test() + Test() == 1)
end)

Test("__sub__ on subtraction", function()
	local Test = class "Test" {
		__sub__ = function() return 1 end
	}
	assert(Test() - Test() == 1)
end)

Test("__mul__ on multiplication", function()
	local Test = class "Test" {
		__mul__ = function() return 1 end
	}
	assert(Test() * Test() == 1)
end)

Test("__div__ on division", function()
	local Test = class "Test" {
		__div__ = function() return 1 end
	}
	assert(Test() / Test() == 1)
end)

Test("__mod__ on modulus", function()
	local Test = class "Test" {
		__mod__ = function() return 1 end
	}
	assert(Test() % Test() == 1)
end)

Test("__pow__ on power", function()
	local Test = class "Test" {
		__pow__ = function() return 1 end
	}
	assert(Test() ^ Test() == 1)
end)

Test("__neg__ on negation", function()
	local Test = class "Test" {
		__neg__ = function() return 1 end
	}
	assert(-Test() == 1)
end)

Test("__cmp__ on comparison", function()
	local mode
	local Test = class "Test" {
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
	local Test = class "Test" {
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
	local Test = class "Test" {
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

Test("Returning of class", function()
	local test = class "Test" {
	}
	assert(test)
end)

Test("Private class definition", function()
	local test = class "TestClass" {
	}
	assert(TestClass == nil)
	assert(test)
end)

Test("__getattr__ not getting other __*__", function()
	local Test = class "Test" {
		__getattr__ = function()
			error("__getattr__ reached")
		end,
	}
	-- __getattr__ used to get called on __*__
	-- in init in the past, make sure it's fixed
	Test()
end)

Test("Number indexes and __*__ getattr prevention", function()
	local Test = class "Test"
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
	local A = class "A"
	{
		test1 = true,
		test2 = function() return true end
	}

	local B = class "B" (A) {}
	local C = class "C" (B) {}
	local D = class "D" (C) {}

	d = D()
	assert(d.test1)
	assert(d.test2())
end)

Test("Double (indirect) inheritance", function()
	local A = class "A"
	{
		test1 = true,
		test2 = function() return true end
	}

	local B = class "B" (A) {}
	local C = class "C" (B, A) {}

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
	local A = class "A"
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

	local A = class "A"
	{
		__attributes__ = {attr}
	}

	assert(called)
end)

Test("Attribute can modify class", function()
	local function attr(class)
		class.cake = true
	end

	local A = class "A"
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

	local A = class "A"
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

	local A = class "A"
	{
		__attributes__ = {attr}
	}

	called = false

	local B = class "B" (A)
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

	local A = class "A"
	{
		__attributes__ = {attr1, attr2}
	}

	assert(A.stage == 2)
end)

Test("Attributes can be anything callable", function()
	local Attribute = class "Attribute"
	{
		called = false,

		__call__ = function(self)
			self.called = true
		end
	}

	local attr = Attribute()

	local A = class "A"
	{
		__attributes__ = {attr}
	}

	assert(attr.called)
end)

Test("Allocate allocates, but does not call the constructor", function()
	local A = class "A"
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
	local A = class "A"
	{
		test1 = true
	}

	local a = getmetatable(A).allocate({test2 = true})
	assert(a.test1)
	assert(a.test2)
end)

Test("Children get added to their direct parents' subclass list", function()
	local A = class "A" {}
	local B = class "B" (A) {}

	assert(A.__subclasses__[B])
end)

Test("Children get added to their indirect parents' subclass list", function()
	local A = class "A" {}
	local B = class "B" (A) {}
	local C = class "C" (B) {}

	assert(A.__subclasses__[C])
end)

Test("class.super finds element from superclass", function()
	local A = class "A"
	{
		test = function()
			return 5
		end,
	}
	local B; B = class "B" (A)
	{
		test = function(self)
			return class.super(B, self, "test")()
		end,
	}

	local b = B()
	assert(b:test() == 5)
	assert(B:test() == 5)
end)

Test("class.super finds no element from superclass if it does not exist", function()
	local A = class "A"
	{
	}

	local B = class "B" (A)
	{
		test = 5,
	}

	local b = B()
	assert(b.test == 5)
	assert(class.super(B, b, "test") == nil)
	assert(B.test == 5)
	assert(class.super(B, B, "test") == nil)
end)

Test("class.super errors on invalid super call", function()
	local A = class "A" {}
	local B = class "B" {}

	local function invalid(inst)
		class.super(A, inst, "test")
	end

	local b = B()
	assert(not pcall(invalid, b))
	assert(not pcall(invalid, B))
end)

Test("class.super finds no element if the root class was used", function()
	local A = class "A"
	{
		test = 5,
	}

	local a = A()
	local root = A.__mro__[#A.__mro__]
	assert(class.super(root, a, "test") == nil)
end)

Test("__new__ can inject members", function()
	local A; A = class "A"
	{
		__new__ = function(self)
			local inst = class.super(A, self, "__new__")(self)
			inst.test = 5
			return inst
		end
	}

	local a = A()
	assert(a.test)
end)

Test("__new__ can return other classes", function()
	local A = class "A"
	{
		test = 5,

		__init__ = function(self)
			assert(self.test == 5)
			self.called = true
		end,
	}

	local B; B = class "B"
	{
		__new__ = function(self)
			return A:__new__()
		end,
	}

	local b = B()
	assert(class.isinstance(b, A))
	assert(b.test == 5)
	assert(b.called)
end)
