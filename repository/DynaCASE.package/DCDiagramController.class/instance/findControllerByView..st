as yet unclassified
findControllerByView: aViewElement
	^ self controllers detect: [ :ctrl | ctrl view = aViewElement ]