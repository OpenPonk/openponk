private
feedbackFor: anObject color: aColor
	(anObject isKindOf: RTElement)
		ifTrue: [ ^ OPElementADFeedback new feedbackFor: anObject color: aColor ].
	(anObject isKindOf: RTEdge)
		ifTrue: [ ^ OPEdgeADFeedback new feedbackFor: anObject color: aColor ].
	(anObject isKindOf: RTView)
		ifTrue: [ ^ OPViewADFeedback new feedbackFor: anObject color: aColor ]