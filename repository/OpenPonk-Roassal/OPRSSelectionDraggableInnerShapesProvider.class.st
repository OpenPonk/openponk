"
Abstract base class for strategies that determine which child or inner shapes should be dragged along when a parent shape is moved.
"
Class {
	#name : 'OPRSSelectionDraggableInnerShapesProvider',
	#superclass : 'Object',
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'asserting' }
OPRSSelectionDraggableInnerShapesProvider >> innerShapesFor: aContainerShape [

	^ self subclassResponsibility
]
