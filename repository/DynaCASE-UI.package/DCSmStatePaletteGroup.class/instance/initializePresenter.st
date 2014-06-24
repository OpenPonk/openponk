initialization
initializePresenter
|element|
	stateButton 
		action: [ 
			(element := DCSmVisualState new).
			self onAction value: element ].
	finalStateButton 
		action: [ 
			(element := DCSmVisualFinalState  new).
			self onAction value: element ].