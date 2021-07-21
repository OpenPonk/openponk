"
Usable for making inner element that should block dragging of outer one
"
Class {
	#name : #OPRTNotDraggable,
	#superclass : #RTAbstractDraggable,
	#category : #'OpenPonk-Roassal2-Interactivity'
}

{ #category : #hooks }
OPRTNotDraggable >> initializeElement: element [
	self
		assert: [ element class ~~ RTView ]
		description: 'Not point in making whole view not draggable this way'.
	element when: TRMouseDragging do: [ :e | "nothing" ]
]
