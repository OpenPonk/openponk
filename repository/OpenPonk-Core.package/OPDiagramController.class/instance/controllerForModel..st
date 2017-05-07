controllers management
controllerForModel: aModel
	aModel = model
		ifTrue: [ ^ self ].
	^ self cachedControllerForModel: aModel
"	^ self controllers detect: [ :ctrl | ctrl model = aModel ]"