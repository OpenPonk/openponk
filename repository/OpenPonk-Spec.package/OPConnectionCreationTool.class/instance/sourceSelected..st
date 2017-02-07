callbacks
sourceSelected: aController
	(aController canBeSourceFor: connectionController)
		ifFalse: [ ^ self ].
	aController addAsSourceFor: connectionController.
	connectionFeedback := connectionController connectionFeedback.
	connectionFeedback renderIn: aController figure view.
	self selectTarget