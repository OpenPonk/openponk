callbacks
targetEntered: aController
	(aController canBeSourceFor: objectController)
		ifTrue: [ self acceptFeedbackFor: aController view ]
		ifFalse: [ self denyFeedbackFor: aController view ]