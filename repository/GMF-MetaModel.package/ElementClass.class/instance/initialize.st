initialize-release
initialize
	super initialize.

	attributes 		:= OrderedCollection new.
	methods 		:= OrderedCollection new.
	associations 	:= OrderedCollection new.
	parents 		:= Set new.
	transformed 	:= false.
	abstract 		:= false.
	generalizationSets := Set new.
	children := Set new.
	
	^ self