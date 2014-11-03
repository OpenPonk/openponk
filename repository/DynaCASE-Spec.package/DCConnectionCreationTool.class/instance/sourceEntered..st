callbacks
sourceEntered: aController
	feedback
		value:
			((aController canBeSourceFor: connectionController)
				ifTrue: [ DCAcceptDenyFeedbackBuilder acceptFeedbackFor: aController view ]
				ifFalse: [ DCAcceptDenyFeedbackBuilder denyFeedbackFor: aController view ])