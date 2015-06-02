initialize-release
initialize
	super initialize.
	
	name 				:= ''.
	parameters 		:= OrderedCollection new.
	returnDataType	:= nil.
	abstract 			:= false.
	instance 			:= true.
	constructor		:= false.

	^self