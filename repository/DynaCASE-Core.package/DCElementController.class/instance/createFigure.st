hooks
createFigure
	^ DCRTCallbackBuilder block: [ :view | self createFigureInView: view ]