accessing
isComplete
	^ complete ifNil: [ complete := true ]
	