interaction
activationView
	^ activationView
		ifNil: [ 
			activationView := RTBox new
				color: Color transparent;
				element.
			DCTRConstraint keepExtentOf: activationView like: self view plus: 2 @ 2.
			TRConstraint stick: activationView onTheCenterOf: self view.
			activationView ]