accessing
controllerForModel: aModel
	aModel = model
		ifTrue: [ ^ self ].
	^ self controllers detect: [ :ctrl | ctrl model = aModel ]