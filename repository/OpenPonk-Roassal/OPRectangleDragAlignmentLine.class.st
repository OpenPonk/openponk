Class {
	#name : #OPRectangleDragAlignmentLine,
	#superclass : #Object,
	#instVars : [
		'dragged',
		'compared'
	],
	#category : #'OpenPonk-Roassal-Interactions'
}

{ #category : #'as yet unclassified' }
OPRectangleDragAlignmentLine class >> dragged: dragged compared: compared [

	^ self new
		  dragged: dragged;
		  compared: compared;
		  yourself
]

{ #category : #'as yet unclassified' }
OPRectangleDragAlignmentLine class >> draggedFirst: draggedFirst draggedSecond: draggedSecond comparedFirst: comparedFirst comparedSecond: comparedSecond [

	| best |
	best := self dragged: draggedFirst compared: comparedFirst.
	{
		(self dragged: draggedFirst compared: comparedSecond).
		(self dragged: draggedSecond compared: comparedFirst).
		(self dragged: draggedSecond compared: comparedSecond) } do: [ :each |
		each resultingDistance > best resultingDistance ifTrue: [
			best := each ] ].
	^ best
]

{ #category : #'as yet unclassified' }
OPRectangleDragAlignmentLine >> adaptation2dOffset [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPRectangleDragAlignmentLine >> adaptationDistance [

	^ self adaptation2dOffset abs
]

{ #category : #'as yet unclassified' }
OPRectangleDragAlignmentLine >> adaptationOffset [

	^ self subclassResponsibility
]

{ #category : #accessing }
OPRectangleDragAlignmentLine >> compared [

	^ compared
]

{ #category : #accessing }
OPRectangleDragAlignmentLine >> compared: aPoint [

	compared := aPoint
]

{ #category : #accessing }
OPRectangleDragAlignmentLine >> dragged [

	^ dragged
]

{ #category : #accessing }
OPRectangleDragAlignmentLine >> dragged: aPoint [

	dragged := aPoint
]

{ #category : #accessing }
OPRectangleDragAlignmentLine >> draggedAdapated [

	^ self dragged + self adaptationOffset
]

{ #category : #'as yet unclassified' }
OPRectangleDragAlignmentLine >> includeOffsetOf: anotherAlignmentLine [

	dragged := dragged translateBy: anotherAlignmentLine adaptationOffset
]

{ #category : #accessing }
OPRectangleDragAlignmentLine >> normalized [

	^ (self dragged - self draggedAdapted) normalized
]

{ #category : #'as yet unclassified' }
OPRectangleDragAlignmentLine >> resultingDistance [

	^ self subclassResponsibility
]
