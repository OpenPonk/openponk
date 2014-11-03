callbacks
targetEntered: aController
	feedback
		value:
			((aController canBeTargetFor: connectionController)
				ifTrue: [ DCAcceptDenyFeedbackBuilder acceptFeedbackFor: aController view ]
				ifFalse: [ DCAcceptDenyFeedbackBuilder denyFeedbackFor: aController view ])