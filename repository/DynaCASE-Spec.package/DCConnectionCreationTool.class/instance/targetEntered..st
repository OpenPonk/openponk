callbacks
targetEntered: aController
	(aController canBeTargetFor: connectionController)
		ifTrue: [ self acceptFeedbackFor: aController view ]
		ifFalse: [ self denyFeedbackFor: aController view ]