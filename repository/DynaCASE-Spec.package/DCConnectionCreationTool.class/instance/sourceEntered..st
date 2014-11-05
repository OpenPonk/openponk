callbacks
sourceEntered: aController
	feedback
		value:
			((aController canBeSourceFor: connectionController)
				ifTrue: [ DCAcceptDenyFeedbackBuilder acceptFeedbackFor: aController figure ]
				ifFalse: [ DCAcceptDenyFeedbackBuilder denyFeedbackFor: aController figure ])