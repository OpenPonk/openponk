Class {
	#name : #OPRectangleDragAlignmentHorizontalLine,
	#superclass : #OPRectangleDragAlignmentLine,
	#category : #'OpenPonk-Roassal-Interactions'
}

{ #category : #accessing }
OPRectangleDragAlignmentHorizontalLine >> adaptation2dOffset [

	^ compared y - dragged y
]

{ #category : #accessing }
OPRectangleDragAlignmentHorizontalLine >> adaptationOffset [

	^ 0 @ self adaptation2dOffset
]

{ #category : #accessing }
OPRectangleDragAlignmentHorizontalLine >> resultingDistance [

	^ (compared x - dragged x) abs
]
