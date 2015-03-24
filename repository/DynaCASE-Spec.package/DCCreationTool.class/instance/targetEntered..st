callbacks
targetEntered: aController
	feedback
		value:
			((aController canBeTargetFor: objectController)
				ifTrue: [ DCAcceptDenyFeedbackBuilder acceptFeedbackFor: aController figure ]
				ifFalse: [ DCAcceptDenyFeedbackBuilder denyFeedbackFor: aController figure ])