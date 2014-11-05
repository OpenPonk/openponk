callbacks
targetEntered: aController
	feedback
		value:
			((aController canBeSourceFor: objectController)
				ifTrue: [ DCAcceptDenyFeedbackBuilder acceptFeedbackFor: aController figure ]
				ifFalse: [ DCAcceptDenyFeedbackBuilder denyFeedbackFor: aController figure ])