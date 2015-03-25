accessing
controllerForModel: aModel
	^ self controllers detect: [ :ctrl | ctrl model = aModel ]