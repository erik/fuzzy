# Fuzzy

**THIS PROJECT IS ENTIRELY IN PROGRESS AND IS NOWHERE NEAR USABLE OR STABLE**

## What?

Fuzzy (working name, will be changed at some point) is a project that
aims to create a simple means of incorporating dynamically scripted
events, mostly aimed at games, but not specifically linked to any one
purpose.

The project is inspired by Elan Ruskin's talk at GDC 2012 entitled
"AI-driven Dynamic Dialog through Fuzzy Pattern Matching" which is
freely available on line:
http://gdcvault.com/play/1015528/AI-driven-Dynamic-Dialog-through

My aim is to generalize and expand the described system such that it
will be adaptable to many different uses and environments.

`demo.fuz` currently describes a (rather contrived) example of
dynamic branching dialog, dependent on speaker and environmental
context.

## Why?

The system as described by Elan Ruskin was wonderfully flexible and a
very easy way to cheaply add in data-driven elements and scriptability
to a system with minimal overhead. I aim to expand on this idea to
address some of the features lacking (autodisabling rules, builtin
namespacing, probability, etc.).

Using Fuzzy (or whatever the name ends up being) should make
generating dynamic scripted events very simple for both developers, as
well as end users.

## How?

The project is currently implemented using Haxe, mostly due to its
quick development cycle and ease of creating demonstrations that will
be available to a cross-platform audience. Should the initial Haxe
implementation be a success, the current plan is to eventually migrate
to C++ for the final implementation, as well as provide several
language bindings, if interest and time allow.

## License

Copyright (c) 2013 Erik Price

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
