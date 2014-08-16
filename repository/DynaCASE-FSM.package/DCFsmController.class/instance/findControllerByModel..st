private
findControllerByModel: aModel
	^ self controllers detect: [ :ctrl | ctrl model = aModel ]