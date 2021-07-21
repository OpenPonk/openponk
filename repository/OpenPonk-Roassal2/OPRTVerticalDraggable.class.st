"
I am an interaction that constraints element dragging in vertical (up/down) direction.
"
Class {
	#name : #OPRTVerticalDraggable,
	#superclass : #RTAbstractDraggable,
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #hooks }
OPRTVerticalDraggable >> transformDistance: distanceAsPoint forElement: anElement [
	^ distanceAsPoint * (0 @ 1)
]
