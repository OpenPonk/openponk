userinterface
updateView
	self controllers
		do: [ :each | 
			each refreshFigure.
			each figure trachelShape triggerCallbacksForStep: 0 @ 0 ]