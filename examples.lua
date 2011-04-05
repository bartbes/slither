require "slither"

class "Food" {
	eaten = false,

	__init__ = function(self, name)
		self.name = name
		print(("Delicious %s created!"):format(name))
	end,

	eat = function(self)
		print(("The %s has been eaten :("):format(self.name))
	end
}

class "Cake" ("Food") {
	eat = function(self)
		print("LIES!")
	end
}

banana = Food("banana")
portal_cake = Cake("Portal Cake")

banana:eat()
portal_cake:eat()
