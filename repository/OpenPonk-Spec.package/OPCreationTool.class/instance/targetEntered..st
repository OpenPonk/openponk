callbacks
targetEntered: aController
	feedback
		value:
			((aController canBeTargetFor: objectController)
				ifTrue: [ aController showAcceptFeedbackFor: objectController ]
				ifFalse: [ aController showDenyFeedbackFor: objectController ])