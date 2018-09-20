"
I provide some primitives for manipulating with rectangles and its sides.

!! Collaborators

DCRTResizable
"
Class {
	#name : #OPRTRectangle,
	#superclass : #Object,
	#classInstVars : [
		'cornerDirections',
		'oppositeCorners'
	],
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #accessing }
OPRTRectangle class >> cornerDirectionFor: aCorner [
	^ self cornerDirections at: aCorner
]

{ #category : #accessing }
OPRTRectangle class >> cornerDirections [
	^ cornerDirections
		ifNil: [ 
			cornerDirections := {#top -> (0 @ 1).
			#bottom -> (0 @ -1).
			#left -> (1 @ 0).
			#right -> (-1 @ 0).
			#topRight -> (-1 @ 1).
			#bottomRight -> (-1 @ -1).
			#bottomLeft -> (1 @ -1).
			#topLeft -> (1 @ 1)} asDictionary ]
]

{ #category : #accessing }
OPRTRectangle class >> corners [
	^ #(#topRight #bottomRight #topLeft #bottomLeft)
]

{ #category : #accessing }
OPRTRectangle class >> cornersAndSides [
	^ {#top.
	#topRight.
	#right.
	#bottomRight.
	#bottom.
	#bottomLeft.
	#left.
	#topLeft}
]

{ #category : #'as yet unclassified' }
OPRTRectangle class >> oppositeCornerFor: aCorner [
	^ self oppositeCorners at: aCorner
]

{ #category : #'as yet unclassified' }
OPRTRectangle class >> oppositeCorners [
	^ oppositeCorners
		ifNil: [ 
			oppositeCorners := {#topRight -> #bottomLeft.
			#bottomLeft -> #topRight.
			#bottomRight -> #topLeft.
			#topLeft -> #bottomRight.
			#top -> #bottom.
			#bottom -> #top.
			#left -> #right.
			#right -> #left} asDictionary ]
]

{ #category : #accessing }
OPRTRectangle class >> sides [
	^ #(#top #right #bottom #left)
]
