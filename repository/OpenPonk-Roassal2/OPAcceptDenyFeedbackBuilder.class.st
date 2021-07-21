Class {
	#name : #OPAcceptDenyFeedbackBuilder,
	#superclass : #RTBuilder,
	#instVars : [
		'feedback'
	],
	#category : 'OpenPonk-Roassal2-Builders'
}

{ #category : #'as yet unclassified' }
OPAcceptDenyFeedbackBuilder class >> acceptFeedbackFor: anObject [
	^ self new acceptFeedbackFor: anObject
]

{ #category : #'as yet unclassified' }
OPAcceptDenyFeedbackBuilder class >> denyFeedbackFor: anObject [
	^ self new denyFeedbackFor: anObject
]

{ #category : #accessing }
OPAcceptDenyFeedbackBuilder >> acceptColor [
	^ Color green
]

{ #category : #protocol }
OPAcceptDenyFeedbackBuilder >> acceptFeedbackFor: anObject [
	^ self feedbackFor: anObject color: self acceptColor
]

{ #category : #accessing }
OPAcceptDenyFeedbackBuilder >> denyColor [
	^ Color red
]

{ #category : #protocol }
OPAcceptDenyFeedbackBuilder >> denyFeedbackFor: anObject [
	^ self feedbackFor: anObject color: self denyColor
]

{ #category : #private }
OPAcceptDenyFeedbackBuilder >> feedbackFor: anObject color: aColor [
	(anObject isKindOf: RTElement)
		ifTrue: [ ^ OPElementADFeedback new feedbackFor: anObject color: aColor ].
	(anObject isKindOf: RTEdge)
		ifTrue: [ ^ OPEdgeADFeedback new feedbackFor: anObject color: aColor ].
	(anObject isKindOf: RTView)
		ifTrue: [ ^ OPViewADFeedback new feedbackFor: anObject color: aColor ]
]

{ #category : #protocol }
OPAcceptDenyFeedbackBuilder >> remove [
	^ self subclassResponsibility
]
