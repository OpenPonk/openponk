Class {
	#name : #OPRSNodeADFeedback,
	#superclass : #OPRSAcceptDenyFeedbackBuilder,
	#category : #'OpenPonk-Roassal3'
}

{ #category : #private }
OPRSNodeADFeedback >> feedbackFor: aShape color: aColor [

	aShape isNode ifFalse: [ ^ self ].
	feedback := (aShape isKindOf: RSCircularShape)
		            ifTrue: [ RSEllipse new ]
		            ifFalse: [ RSBox new ].
	(aShape respondsTo: #cornerRadius) ifTrue: [ 
		feedback cornerRadius: aShape cornerRadius ].
	feedback
		color: (aColor alpha: 0.2);
		borderColor: (aColor alpha: 0.2).
	OPRSResize new
		shapes: { feedback };
		fixedShape: aShape;
		oversize: 3 @ 3;
		stickSameSize.
	RSLocation new stick: feedback on: aShape.
	aShape canvas add: feedback.
	aShape signalUpdate.
]

{ #category : #protocol }
OPRSNodeADFeedback >> remove [

	| canvas |
	feedback ifNil: [ ^ self ].
	canvas := feedback canvas.
	feedback remove.
	canvas signalUpdate.
	feedback := nil
]
