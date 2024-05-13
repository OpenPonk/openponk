Class {
	#name : 'OPRSSelectionDraggableContainedShapesProvider',
	#superclass : 'OPRSSelectionDraggableInnerShapesProvider',
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'asserting' }
OPRSSelectionDraggableContainedShapesProvider >> innerShapesFor: aContainerShape [

	| containerRectangle |
	containerRectangle := aContainerShape encompassingRectangle.
	^ aContainerShape canvas nodes select: [ :each | 
		  each isFixed not and: [ 
			  (containerRectangle containsRect: each encompassingRectangle) 
				  and: [ containerRectangle ~= each encompassingRectangle ] ] ]
]
