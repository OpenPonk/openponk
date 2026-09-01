"
Vertical alignment line used to calculate X-axis snapping offsets between dragged and static rectangles.
"
Class {
	#name : 'OPRectangleDragAlignmentVerticalLine',
	#superclass : 'OPRectangleDragAlignmentLine',
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'accessing' }
OPRectangleDragAlignmentVerticalLine >> adaptation2dOffset [

	^ compared x - dragged x
]

{ #category : 'accessing' }
OPRectangleDragAlignmentVerticalLine >> adaptationOffset [

	^ self adaptation2dOffset @ 0
]

{ #category : 'accessing' }
OPRectangleDragAlignmentVerticalLine >> resultingDistance [

	^ (compared y - dragged y) abs
]
