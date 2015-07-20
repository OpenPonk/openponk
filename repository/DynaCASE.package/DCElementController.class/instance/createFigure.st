hooks
createFigure
	^ DCRTCallbackBuilder block: [ :view | self createFigureIn: view ]