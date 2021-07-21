Class {
	#name : #OPElementADFeedback,
	#superclass : #OPAcceptDenyFeedbackBuilder,
	#instVars : [
		'noBorder'
	],
	#category : 'OpenPonk-Roassal2-Builders'
}

{ #category : #private }
OPElementADFeedback >> feedbackFor: anElement color: aColor [
	| shape |
	(anElement isKindOf: RTElement)
		ifFalse: [ ^ self ].
	shape := RTBox new.
	anElement shape class = RTRoundedBox
		ifTrue:
			[ (shape := RTRoundedBox new) borderRadius: (anElement shape borderRadiusFor: anElement) ].
	anElement shape class = RTEllipse
		ifTrue: [ shape := RTEllipse new ].
	feedback := shape
		color: (aColor alpha: 0.2);
		borderColor: (aColor alpha: 0.2);
		element.
	noBorder
		ifTrue: [ feedback trachelShape strokeWidth: 0.
			feedback trachelShape strokePaint: Color red ].
	OPRTElementsConstraint keepExtentOf: feedback like: anElement plus: 3 @ 3.
	TRConstraint stick: feedback onTheCenterOf: anElement.
	anElement view add: feedback.
	anElement view signalUpdate
]

{ #category : #initialization }
OPElementADFeedback >> initialize [
	super initialize.
	noBorder := false
]

{ #category : #'as yet unclassified' }
OPElementADFeedback >> noBorder [
	noBorder := true
]

{ #category : #protocol }
OPElementADFeedback >> remove [
	feedback
		ifNotNil: [ 
			| aView |
			aView := feedback view.
			feedback remove.
			aView signalUpdate.
			feedback := nil ]
]
