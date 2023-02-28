Class {
	#name : #OPRSAcceptDenyFeedbackBuilder,
	#superclass : #RSObject,
	#instVars : [
		'feedback'
	],
	#category : #'OpenPonk-Roassal3-CreationFeedback'
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
		self error:
			'Can only provide creation feedback for Roassal3 shapes and canvas, not for '
			, anObject className ].
	^ (anObject isShape
		   ifTrue: [ 
			   anObject isLine
				   ifTrue: [ OPRSLineADFeedback ]
				   ifFalse: [ OPRSNodeADFeedback ] ]
		   ifFalse: [ OPRSCanvasADFeedback ]) new
		  feedbackFor: anObject
		  color: aColor
]

{ #category : #protocol }
OPRSAcceptDenyFeedbackBuilder >> remove [
	^ self subclassResponsibility
]
