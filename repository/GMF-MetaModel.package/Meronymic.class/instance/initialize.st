initialize-release
initialize
	super initialize.

	essential 			:= false.
	immutablePart 		:= false.
	immutableWhole 	:= false.
	inseparable 		:= false.
	shareable			:= false.

	^self