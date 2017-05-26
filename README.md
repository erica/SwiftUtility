# Swift Utility

Useful stuff. BSD. Use at your own risk.

A lot of these are "notes" and have not been tested

# Cartesian Product
* What it says on the label

# CharacterSet
* Don't know if I'll keep this long term, but character set members

# Collection
* Useful stuff, not fully updated to Swift 4 See "TODO"s

# Core Error
* Basic utility error
* Contextualizing
* ContextError
* Common Error Handler type
* `attempt` (replaces `try?` and `try!`) and Boolean variation `testAttempt`

# Diagnosis
* Postfix printing
	* Also debug-only version, which requires compilation flags
	* Also `dump`-enabled high octane versions
* Diagnostic printing
	* `here`: The current file and line number
	* `diagnose(object)`: shows the object in detail with pass-through
* Infix printing
	* offers low-precedence forward-looking print or dump functionality

# Dispatch
* General timing and invocation utilities

# Math
* Exponentiation
* Double unification

# Nostalgia
* Prefix, Postfix increment/decrement

# Optional
* Controlled landings for forced unwraps
* `do` instead of optional.map(action)
* Conditional map/flatmap application
* Zipping optionals / flatmap2 for optionals

# Optional Comparison
* What it says on the box. Follows IEEE754 wrt NaN

# Precedence
* Custom items including very low and very high

# Reflection
* Self-reflecting reference types

# Splatting
* 2-, 3-, 4- item

# TimeTest
* Avoid using in playgrounds

# Unimplemented
* Clean line/source info

# With
* Flexible initialization and immutable assignment

# Moved from Sources
Most operators have been moved out of the main sources into `Various`
* Casting
  * Force cast to the type demanded by static context (Groffcast)
  * Unsafe bitcast constrained to equal memory footprint (Ashcast)
  * Dynamic type dispatch (Dynogroff)
  * Dynamic casting without bridging (Groffchoo)
* Assignment
  * In-place value assignment (EridiusAssignment)
  * Conditional in-place assignment (Ashignment)
* Failable and direct chaining (ChainChainChainOfFools operator)
* Interesting things that caught my eye
* Notes on stuff that I'm looking at at the moment
