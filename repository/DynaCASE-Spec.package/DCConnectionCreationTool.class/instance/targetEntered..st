callbacks
targetEntered: aController
	feedback
		value:
			((aController canBeTargetFor: connectionController)
				ifTrue: [ DCAcceptDenyFeedbackBuilder acceptFeedbackFor: aController figure ]
				ifFalse: [ DCAcceptDenyFeedbackBuilder denyFeedbackFor: aController figure ])