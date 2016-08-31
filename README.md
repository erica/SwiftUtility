# Swift Utility

Useful stuff. BSD. Use at your own risk.

# Nostalgia
* Prefix, Postfix increment/decrement

# Operators
* Casting
  * Force cast to the type demanded by static context (Groffcast)
  * Unsafe bitcast constrained to equal memory footprint (Ashcast)
  * Dynamic type dispatch (Dynogroff)
  * Dynamic casting without bridging (Groffchoo)
* Assignment
  * In-place value assignment (EridiusAssignment)
  * Conditional in-place assignment (Ashignment)
* Failable and direct chaining (ChainChainChainOfFools operator)

# Diagnosis
* Postfix printing
	* Also debug-only version, which requires compilation flags
	* Also `dump`-enabled high octane versions
* Diagnostic printing
	* `here`: The current file and line number
	* `diagnose(object)`: shows the object in detail with pass-through
* Infix printing
	* offers low-precedence forward-looking print or dump functionality

# General Utility
* Time testing (`timetest`)
* Immutable assignment (`with`)
* Default class reflection for reference types (`DefaultReflectable`)
* Clamping to range (`clamp(_:to:)`)
* splatMapping:
	* Zipping optionals
	* Returning a tuple-parameterized version of a 2-argument function
	* flatMap2: a 2-argument version of flatMap

# Optional Comparisons
* Failable Optional Comparisons
 
# Common Core errors
* Basic utility error
* Contextualizing
* ContextError
* Common Error Handler type
* `attempt` (replaces `try?` and `try!`) and Boolean variation `testAttempt`

### Note:
I'm still updating SwiftCollections to Swift 3. They're removed from the repo until I get them sorted out


