initialize-release
initialize
	super initialize.

	name 			:= nil.
	attributes 		:= Set new.
	methods 		:= Set new.
	associations 	:= Set new.
	parents 		:= Set new.
	transformed 	:= false.
	abstract 		:= false.
	
	^ self