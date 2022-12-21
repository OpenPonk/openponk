Class {
	#name : #OPRSLineADFeedback,
	#superclass : #OPRSAcceptDenyFeedbackBuilder,
	#category : #'OpenPonk-Roassal3'
}

{ #category : #private }
OPRSLineADFeedback >> feedbackFor: anEdge color: aColor [

	feedback := anEdge.
	(anEdge hasProperty: self originalColorSymbol) ifTrue: [ ^ self ].
	anEdge propertyAt: self originalColorSymbol put: anEdge color.
	anEdge color: aColor.
	anEdge signalUpdate
]

{ #category : #accessing }
OPRSLineADFeedback >> originalColorSymbol [
	^ #adFeedbackOriginalColor
]

{ #category : #protocol }
OPRSLineADFeedback >> remove [

	(feedback hasProperty: self originalColorSymbol) ifFalse: [ ^ self ].
	feedback color: (feedback propertyAt: self originalColorSymbol).
	feedback removePropertyAt: self originalColorSymbol.
	feedback signalUpdate
]
