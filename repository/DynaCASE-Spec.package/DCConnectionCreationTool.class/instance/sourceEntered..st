callbacks
sourceEntered: aController
	(aController canBeSourceFor: connectionController)
		ifTrue: [ self acceptFeedbackFor: aController view ]
		ifFalse: [ self denyFeedbackFor: aController view ]