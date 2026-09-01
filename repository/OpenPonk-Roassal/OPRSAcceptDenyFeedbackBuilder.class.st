"
Utility builder that creates visual feedback overlays (typically colored highlights) on Roassal shapes to indicate whether an ongoing operation (like drag-and-drop or connection) is accepted or denied by a target controller.
"
Class {
	#name : 'OPRSAcceptDenyFeedbackBuilder',
	#superclass : 'RSObject',
	#instVars : [
		'feedback'
	],
	#category : 'OpenPonk-Roassal-CreationFeedback',
	#package : 'OpenPonk-Roassal',
	#tag : 'CreationFeedback'
}

{ #category : 'visiting' }
OPRSAcceptDenyFeedbackBuilder class >> acceptFeedbackFor: anObject [
	^ self new acceptFeedbackFor: anObject
]

{ #category : 'asserting' }
OPRSAcceptDenyFeedbackBuilder class >> denyFeedbackFor: anObject [
	^ self new denyFeedbackFor: anObject
]

{ #category : 'accessing' }
OPRSAcceptDenyFeedbackBuilder >> acceptColor [
	^ Color green
]

{ #category : 'protocol' }
OPRSAcceptDenyFeedbackBuilder >> acceptFeedbackFor: anObject [
	^ self feedbackFor: anObject color: self acceptColor
]

{ #category : 'accessing' }
OPRSAcceptDenyFeedbackBuilder >> denyColor [
	^ Color red
]

{ #category : 'protocol' }
OPRSAcceptDenyFeedbackBuilder >> denyFeedbackFor: anObject [
	^ self feedbackFor: anObject color: self denyColor
]

{ #category : 'private' }
OPRSAcceptDenyFeedbackBuilder >> feedback [

	^ feedback
]

{ #category : 'private' }
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

{ #category : 'protocol' }
OPRSAcceptDenyFeedbackBuilder >> remove [
	^ self subclassResponsibility
]
