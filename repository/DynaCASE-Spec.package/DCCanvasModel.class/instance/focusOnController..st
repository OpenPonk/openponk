selection handling
focusOnController: aController
	focusedController = aController
		ifFalse: [ 
			focusedController := aController.
			self owner focusOn: aController.
			self signalUpdate ]