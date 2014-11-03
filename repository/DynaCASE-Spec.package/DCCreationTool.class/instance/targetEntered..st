callbacks
targetEntered: aController
	feedback
		value:
			((aController canBeSourceFor: objectController)
				ifTrue: [ DCAcceptDenyFeedbackBuilder acceptFeedbackFor: aController view ]
				ifFalse: [ DCAcceptDenyFeedbackBuilder denyFeedbackFor: aController view ])