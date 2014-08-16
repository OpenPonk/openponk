as yet unclassified
findControllerByModel: aModel
	^ self controllers detect: [ :ctrl | ctrl model = aModel ]