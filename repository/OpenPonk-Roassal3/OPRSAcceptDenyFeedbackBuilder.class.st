Class {
	#name : #OPRSAcceptDenyFeedbackBuilder,
	#superclass : #RSObject,
	#instVars : [
		'feedback'
	],
	#category : #'OpenPonk-Roassal3'
}

{ #category : #'as yet unclassified' }
OPRSAcceptDenyFeedbackBuilder class >> acceptFeedbackFor: anObject [
	^ self new acceptFeedbackFor: anObject
]

{ #category : #'as yet unclassified' }
OPRSAcceptDenyFeedbackBuilder class >> denyFeedbackFor: anObject [
	^ self new denyFeedbackFor: anObject
]

{ #category : #accessing }
OPRSAcceptDenyFeedbackBuilder >> acceptColor [
	^ Color green
]

{ #category : #protocol }
OPRSAcceptDenyFeedbackBuilder >> acceptFeedbackFor: anObject [
	^ self feedbackFor: anObject color: self acceptColor
]

{ #category : #accessing }
OPRSAcceptDenyFeedbackBuilder >> denyColor [
	^ Color red
]

{ #category : #protocol }
OPRSAcceptDenyFeedbackBuilder >> denyFeedbackFor: anObject [
	^ self feedbackFor: anObject color: self denyColor
]

{ #category : #private }
OPRSAcceptDenyFeedbackBuilder >> feedback [

	^ feedback
]

{ #category : #private }
OPRSAcceptDenyFeedbackBuilder >> feedbackFor: anObject color: aColor [

	(anObject respondsTo: #isShape) ifFalse: [ 
		self error: 'Cannot provide feedback for ' , anObject className ].
	(anObject isShape and: [ anObject isNode ]) ifTrue: [ 
		^ OPRSNodeADFeedback new feedbackFor: anObject color: aColor ].
	(anObject isShape and: [ anObject isLine ]) ifTrue: [ 
		^ OPRSLineADFeedback new feedbackFor: anObject color: aColor ].
	anObject isShape ifFalse: [ 
		^ OPRSCanvasADFeedback new feedbackFor: anObject color: aColor ]
]

{ #category : #protocol }
OPRSAcceptDenyFeedbackBuilder >> remove [
	^ self subclassResponsibility
]
