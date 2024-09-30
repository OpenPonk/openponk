Class {
	#name : 'OPRSSelectionDraggableSmallerOverlappingShapesProvider',
	#superclass : 'OPRSSelectionDraggableInnerShapesProvider',
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'asserting' }
OPRSSelectionDraggableSmallerOverlappingShapesProvider >> innerShapesFor: aContainerShape [

	| containerRectangle |
	containerRectangle := aContainerShape encompassingRectangle.
	^ aContainerShape canvas nodes select: [ :each | 
		  each isFixed not and: [ 
			  | intersection |
			  intersection := containerRectangle intersect:
				                  each encompassingRectangle.
			  intersection width > 1.99 and: [ 
				  intersection height > 1.99 and: [ 
					  containerRectangle area > each encompassingRectangle area ] ] ] ]
]
