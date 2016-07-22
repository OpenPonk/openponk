canvas actions
showAcceptFeedbackFor: aController
	"Return something that understands #remove, or nil to not show any feedback."

	^ DCAcceptDenyFeedbackBuilder acceptFeedbackFor: self figure