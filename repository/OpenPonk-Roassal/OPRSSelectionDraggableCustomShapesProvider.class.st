Class {
	#name : 'OPRSSelectionDraggableCustomShapesProvider',
	#superclass : 'OPRSSelectionDraggableInnerShapesProvider',
	#instVars : [
		'block'
	],
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'instance creation' }
OPRSSelectionDraggableCustomShapesProvider class >> withBlock: aFullBlockClosure [

	^ self new
		  block: aFullBlockClosure;
		  yourself
]

{ #category : 'asserting' }
OPRSSelectionDraggableCustomShapesProvider >> block: aBlock [

	block := aBlock
]

{ #category : 'asserting' }
OPRSSelectionDraggableCustomShapesProvider >> initialize [

	super initialize.
	self block: [ Set empty ]
]

{ #category : 'asserting' }
OPRSSelectionDraggableCustomShapesProvider >> innerShapesFor: aContainerShape [

	^ block cull: aContainerShape canvas nodes cull: aContainerShape
]
