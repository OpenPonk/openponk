callbacks
sourceEntered: aController
	feedback
		value:
			((aController canBeSourceFor: connectionController)
				ifTrue: [ aController showAcceptFeedbackFor: connectionController ]
				ifFalse: [ aController showDenyFeedbackFor: connectionController ])