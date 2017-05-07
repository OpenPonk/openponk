figures
createFigure
	^ OPRTCallbackBuilder block: [ :view | self createFigureInView: view ]