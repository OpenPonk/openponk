Class {
	#name : #OPRSLineADFeedback,
	#superclass : #OPRSAcceptDenyFeedbackBuilder,
	#category : #'OpenPonk-Roassal-CreationFeedback'
}

{ #category : #private }
OPRSLineADFeedback >> feedbackFor: aLine color: aColor [

	feedback := aLine.
	(feedback hasProperty: self originalColorSymbol) ifTrue: [ ^ self ].
	feedback propertyAt: self originalColorSymbol put: feedback color.
	feedback color: aColor.
	feedback signalUpdate
]

{ #category : #accessing }
OPRSLineADFeedback >> originalColorSymbol [
	^ #adFeedbackOriginalColor
]

{ #category : #protocol }
OPRSLineADFeedback >> remove [

	feedback ifNil: [ ^ self ].
	(feedback hasProperty: self originalColorSymbol) ifFalse: [ ^ self ].
	feedback color: (feedback propertyAt: self originalColorSymbol).
	feedback removePropertyAt: self originalColorSymbol.
	feedback signalUpdate.
	feedback := nil
]
