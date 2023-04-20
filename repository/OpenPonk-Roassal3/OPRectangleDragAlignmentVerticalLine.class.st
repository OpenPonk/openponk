Class {
	#name : #OPRectangleDragAlignmentVerticalLine,
	#superclass : #OPRectangleDragAlignmentLine,
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #'as yet unclassified' }
OPRectangleDragAlignmentVerticalLine >> adaptation2dOffset [

	^ compared x - dragged x
]

{ #category : #'as yet unclassified' }
OPRectangleDragAlignmentVerticalLine >> adaptationOffset [

	^ self adaptation2dOffset @ 0
]

{ #category : #'as yet unclassified' }
OPRectangleDragAlignmentVerticalLine >> resultingDistance [

	^ (compared y - dragged y) abs
]
