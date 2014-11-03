private
feedbackFor: anObject color: aColor
	(anObject isKindOf: RTElement)
		ifTrue: [ ^ DCElementADFeedback new feedbackFor: anObject color: aColor ].
	(anObject isKindOf: RTEdge)
		ifTrue: [ ^ DCEdgeADFeedback new feedbackFor: anObject color: aColor ].
	(anObject isKindOf: RTView)
		ifTrue: [ ^ DCViewADFeedback new feedbackFor: anObject color: aColor ]