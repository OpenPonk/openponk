Class {
	#name : #OPRSKeyNavigationCanvasInteraction,
	#superclass : #RSKeyNavigationCanvasInteraction,
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #events }
OPRSKeyNavigationCanvasInteraction >> processKeyDown: evt [

	| keyName |
	keyName := evt keyName.
	keyName = #I ifTrue: [ ^ self ].
	keyName = #O ifTrue: [ ^ self ].
	(#( #+ #PLUS #KP_ADD ) includes: keyName) ifTrue: [
		^ self zoomIn: evt canvas ].
	(#( #- #MINUS #KP_SUBTRACT ) includes: keyName) ifTrue: [
		^ self zoomOut: evt canvas ].
	^ super processKeyDown: evt
]
