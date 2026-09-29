"
Abstract base class for tools residing within the OpenPonk palette (such as selection, node creation, and connection routing tools).
"
Class {
	#name : 'OPPaletteTool',
	#superclass : 'Object',
	#instVars : [
		'palette'
	],
	#category : 'OpenPonk-Spec-Palettes',
	#package : 'OpenPonk-Spec',
	#tag : 'Palettes'
}

{ #category : 'protocol' }
OPPaletteTool >> deselect [

	self subclassResponsibility
]

{ #category : 'hooks' }
OPPaletteTool >> deselectController: aController [
	"Polymorphic hook for tools handling selection. Subclasses override as needed." 
]

{ #category : 'accessing' }
OPPaletteTool >> diagramController [
	^ palette diagramController
]

{ #category : 'protocol' }
OPPaletteTool >> disableMultiselect [

	(self diagramController canvas propertyAt: OPRSSelectableCanvas)
		disableMultiselect
]

{ #category : 'accessing' }
OPPaletteTool >> editor [
	^ palette editor
]

{ #category : 'protocol' }
OPPaletteTool >> enableMultiselect [

	self diagramController canvas
		propertyAt: OPRSSelectableCanvas
		ifPresent: [ :selectableCanvas | selectableCanvas enableMultiselect ]
]

{ #category : 'hooks' }
OPPaletteTool >> hoveredController: aController [

	"do nothing by default"
]

{ #category : 'accessing' }
OPPaletteTool >> palette [
	^ palette
]

{ #category : 'accessing' }
OPPaletteTool >> palette: aPalette [

	palette := aPalette
]

{ #category : 'protocol' }
OPPaletteTool >> select [

	self subclassResponsibility
]

{ #category : 'hooks' }
OPPaletteTool >> selectedControllers: aCollectionOfControllers [

	^ self subclassResponsibility
]

{ #category : 'canvas events' }
OPPaletteTool >> selectedControllers: aCollection onPosition: aPoint [
	self selectedControllers: aCollection
]

{ #category : 'accessing' }
OPPaletteTool >> workbench [
	^ palette workbench
]
