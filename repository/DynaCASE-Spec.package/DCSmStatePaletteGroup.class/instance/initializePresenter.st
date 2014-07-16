initialization
initializePresenter
	| element shape label |
	stateButton
		action: [ 
			element := RTElement new.
			shape := DCRoassalSmSimpleState new size: 50; borderColor: Color black.
			label := (RTLabel new)
				text: 'Label';
				height: 10.
			element + shape.
			element + label.
			self onAction value: element ].
	finalStateButton
		action: [ 
			element := RTElement new.
			shape := DCRoassalSmFinalState new size: 25; color: Color black.
			element + shape.
			self onAction value: element ]