require "slither"

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

assert(isinstance(chocolate_banana, Food) and isinstance(portal_cake, Food) and issubclass(foods.Cake, Food) and issubclass(foods.Cake, foods.Cake) and not issubclass(Food, foods.Cake), "Inheritance checking is wrong")
