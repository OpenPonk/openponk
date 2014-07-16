initialization
initializePresenter
|element|
	transitionButton 
		action: [ 
			(element := DCSmVisualTransition  new)
				addPoint: 0 @ 15;
				addPoint: 10 @ 155;
				addPoint: 200 @ 15 .
				element endPoint: (element pointHandles last).
				element neighbourPoint: (element pointHandles at: 2).
			self onAction value: element ]