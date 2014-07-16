initialization
initializePresenter
	| element shape |
	initialButton
		action: [ 
			element := RTElement new.
			shape := (DCRoassalSmInitialState new)
				size: 25;
				color: Color black.
			element + shape.
			self onAction value: element ].
	forkButton
		action: [ 
			element := DCSmVisualFork new.
			self onAction value: element ]