**Slither** is a class library for lua that mimics python's classes, at the moment it has one big exception:

- The class name is specified as a string

This means that:

    class Cake (Food):
      pass

becomes

    class "Cake" (Food) {
    }


If you just want to use the library, slither.lua is the file you'll want, examples are present in examples.lua.

Documentation can be found at [my documentation wiki](http://docs.bartbes.com/slither)

Enjoy!

(P.S. Do feel free to report any bugs you might encounter)
