private
findControllerByView: aViewElement
	^ self controllers detect: [ :ctrl | ctrl view = aViewElement ]