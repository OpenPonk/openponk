callbacks
sourceSelected: aController
	(aController canBeSourceFor: connectionController)
		ifTrue: [ 
			aController addAsSourceFor: connectionController.
			connectionFeedback := connectionController connectionFeedback.
			connectionFeedback renderIn: aController figure view.
			self selectTarget ]