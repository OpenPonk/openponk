Class {
	#name : #OPEdgeADFeedback,
	#superclass : #OPAcceptDenyFeedbackBuilder,
	#category : 'OpenPonk-Roassal2-Builders'
}

{ #category : #private }
OPEdgeADFeedback >> feedbackFor: anEdge color: aColor [
	feedback := anEdge.
	(anEdge attributes includesKey: self originalColorSymbol)
		ifTrue: [ ^ self ].
	anEdge attributes at: self originalColorSymbol put: anEdge shape color.
	anEdge shape color: aColor.
	anEdge update.
	anEdge view signalUpdate
]

{ #category : #accessing }
OPEdgeADFeedback >> originalColorSymbol [
	^ #adFeedbackOriginalColor
]

{ #category : #protocol }
OPEdgeADFeedback >> remove [
	(feedback attributes includesKey: self originalColorSymbol)
		ifFalse: [ ^ self ].
	feedback shape color: (feedback attributes at: self originalColorSymbol).
	feedback attributes removeKey: self originalColorSymbol.
	feedback update.
	feedback view signalUpdate
]
