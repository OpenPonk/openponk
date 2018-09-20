"
I am draggable that rounds the movement distance to the nearest integer. No more float suffering!
"
Class {
	#name : #OPRTRoundedDraggable,
	#superclass : #RTDraggable,
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #hooks }
OPRTRoundedDraggable >> initializeElement: anElement [
	self
		assert: [ anElement class ~~ RTView ]
		description: 'Please use RTDraggableView instead'.
	anElement
		when: TRMouseDragging
		do:
			[ :e | 
			| d t |
			t := RTGroup withAll: groupToDrag.
			(t includes: anElement)
				ifFalse: [ t add: anElement ].
			anElement view
				ifNotNil:
					[ d := anElement view canvas camera distanceFromPixelToSpace: e step.
					t translateBy: (self transformDistance: d forElement: anElement).
					self constraintIfNecessary: anElement.
					e signalUpdate ] ]
]

{ #category : #hooks }
OPRTRoundedDraggable >> transformDistance: distanceAsPoint forElement: anElement [
	"anElement can be at non-integer position, so account for it"

	^ (anElement position + distanceAsPoint) rounded - anElement position
]
