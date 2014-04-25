Defining a class
================

The basic syntax for defining a class is as follows:

	class "ClassName"
	{
	}

This creates a new class, named `ClassName`, and sets the
global variable `ClassName` to point to this class.


Inheritance
-----------

If we first define the parent class as:

	class "ParentClass"
	{
	}

we can then define a subclass as follows:

	class "Subclass" (ParentClass)
	{
	}

`Subclass` will have inherited all members, including methods
from `ParentClass`.

Slither also supports multiple inheritance and there is a
well-defined order in which inherited members are looked up.
This order is in the left-to-right order of definition, recursively.
That is, if we have a tree like follows:

	A  B  C  D
	 \ | /   |
	   E     F
	    \   /
	     \ /
          G

If a member is missing in all of these classes, the lookup order (starting at G)
shall be: G, E, A, B, C, F, D.


Helper functions
================

Slither also defines the functions `issubclass` and `isinstance`,
which determine recursively whether a class is derived from another,
or an object is an instance of a class, or its subclasses, respetively.

`issubclass` allows for the following invocations:

	boolean = issubclass(class, parent)
	boolean = issubclass(class, {parents...})

`isinstance` allows for the following invocation:

	boolean = isinstance(object, parent)
	boolean = isinstance(object, {parents...})


Special methods and members
===========================

Predefined members
------------------

 - `__class__`: Returns the class this object is an instance of.
 - `__name__`: Returns the name of this object's class.

Overrides
---------

 - `__cmp__`: Overrides most comparison operators, gets called with
              two arguments, return 0 when they are equal, a negative
              number if a is less than b, and a positive number otherwise.
 - `__call__`: Gets called when the object is called like a function.
 - `__len__`: Override the length returned using the length (`#`) operator.
 - `__add__`: Overrides addition.
 - `__sub__`: Overrides subtraction.
 - `__mul__`: Overrides multiplication.
 - `__div__`: Overrides division.
 - `__mod__`: Overrides the modulo operation.
 - `__pow__`: Overrides the power (`^`) operator.
 - `__neg__`: Overrides the unary minus (or negation).
 - `__getattr__`: Overrides the return value of an undefined index operation.
 - `__setattr__`: Overrides the result of setting an undefined member.


Miscellaneous features
======================

- [Class Commons][] support

[Class Commons]: https://github.com/bartbes/Class-Commons
