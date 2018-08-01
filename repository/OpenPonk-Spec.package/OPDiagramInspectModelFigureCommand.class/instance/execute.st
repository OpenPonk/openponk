execution
execute
	models ifEmpty: [ ^ self ].
	models size = 1
		ifTrue: [ models first inspect ]
		ifFalse: [ models inspect ]