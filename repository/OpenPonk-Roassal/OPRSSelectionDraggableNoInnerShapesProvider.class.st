"
Selection strategy that explicitly prevents any inner or child shapes from being dragged along with a parent shape.
"
Class {
	#name : 'OPRSSelectionDraggableNoInnerShapesProvider',
	#superclass : 'OPRSSelectionDraggableInnerShapesProvider',
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'asserting' }
OPRSSelectionDraggableNoInnerShapesProvider >> innerShapesFor: aContainerShape [

	^ Set new
]
