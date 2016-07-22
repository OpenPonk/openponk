canvas actions
showDenyFeedbackFor: aController
	"Return something that understands #remove, or nil to not show any feedback."

	^ DCAcceptDenyFeedbackBuilder denyFeedbackFor: self figure