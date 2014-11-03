initialize-release
initialize
	super initialize.
	
	name 				:= nil.
	parameters 		:= OrderedCollection new.
	returnDataType	:= nil.
	abstract 			:= false.
	instance 			:= true.
	constructor			:= false.

	^self