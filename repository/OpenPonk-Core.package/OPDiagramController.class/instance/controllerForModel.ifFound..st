controllers management
controllerForModel: aModel ifFound: aFoundBlock
	aModel = model
		ifTrue: [ ^ self ].
	^ self cachedControllerForModel: aModel ifFound: aFoundBlock
"	^ self controllers detect: [ :ctrl | ctrl model = aModel ]"