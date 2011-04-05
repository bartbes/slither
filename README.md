**Slither** is a class library for lua that mimics python's classes, at the moment it has two big exceptions:

- The class name is specified as a string
- The class name of the parent(s) is specified as strings

This means that:
    class Cake (Food):
      pass
becomes
    class "Cake" ("Food") {
    }

If you just want to use the library, slither.lua is the file you'll want, examples are present in examples.lua.

Enjoy!

(P.S. Do feel free to report any bugs you might encounter)
