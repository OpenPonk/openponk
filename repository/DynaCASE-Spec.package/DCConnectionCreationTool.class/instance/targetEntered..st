callbacks
targetEntered: aController
	feedback
		value:
			((aController canBeTargetFor: connectionController)
				ifTrue: [ aController showAcceptFeedbackFor: connectionController ]
				ifFalse: [ aController showDenyFeedbackFor: connectionController ])