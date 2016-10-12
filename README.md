OpenGL module for ChezScheme
============================

ChezScheme comes with an OpenGL module, but that doesn't support the latest
and greatest versions of OpenGL. This packages parses the Khronos registry 
for OpenGL standards and creates bindings for OpenGL for whichever version 
you need.

I tried to stick to R6RS code as much as possible, so it should be possible
to port this to other scheme systems. Where there are imports from `(chezscheme)`, they are done with `(import (only (chezscheme) ...))`.


## Future

* Load OpenGL extensions at runtime: I'm not sure how to achieve this 
  within the confines of the hygienic Scheme system.
* Higher level Scheme interface.


## Requirements

* R6RS scheme
* Lyonesse - my own little pack of batteries; it has a minimal XML parser.
* SRFI's 13 (string tools) and 48 (format)
* GLFW - to create an OpenGL context, and access to keyboard, mouse etc.