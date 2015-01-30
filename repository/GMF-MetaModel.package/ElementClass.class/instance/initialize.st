initialize-release
initialize
	super initialize.

	name 			:= nil.
	attributes 		:= #().
	methods 		:= #().
	associations 	:= Set new.
	parents 		:= Set new.
	transformed 	:= false.
	abstract 		:= false.
	
	^ self