"
I am an interaction that constraints element dragging in horizontal (left/right) direction.
"
Class {
	#name : #OPRTHorizontalDraggable,
	#superclass : #RTAbstractDraggable,
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #hooks }
OPRTHorizontalDraggable >> transformDistance: distanceAsPoint forElement: anElement [
	^ distanceAsPoint * (1 @ 0)
]
