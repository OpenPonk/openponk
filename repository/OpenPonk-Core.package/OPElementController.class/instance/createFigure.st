hooks
createFigure
	^ OPRTCallbackBuilder block: [ :view | self createFigureInView: view ]