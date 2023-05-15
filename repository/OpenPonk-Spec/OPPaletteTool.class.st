"
An abstract base class for all palette tools.
To create new tool override >>select  (and optionaly >>deselect) methods.
"
Class {
	#name : #OPPaletteTool,
	#superclass : #Object,
	#instVars : [
		'palette'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #protocol }
OPPaletteTool >> deselect [

	self subclassResponsibility
]

{ #category : #accessing }
OPPaletteTool >> diagramController [
	^ palette diagramController
]

{ #category : #protocol }
OPPaletteTool >> disableMultiselect [

	(self diagramController canvas propertyAt: OPRSSelectableCanvas)
		disableMultiselect
]

{ #category : #accessing }
OPPaletteTool >> editor [
	^ palette editor
]

{ #category : #protocol }
OPPaletteTool >> enableMultiselect [

	self diagramController canvas
		propertyAt: OPRSSelectableCanvas
		ifPresent: [ :selectableCanvas | selectableCanvas enableMultiselect ]
]

{ #category : #'as yet unclassified' }
OPPaletteTool >> hoveredController: aController [

	"do nothing by default"
]

{ #category : #accessing }
OPPaletteTool >> palette [
	^ palette
]

{ #category : #accessing }
OPPaletteTool >> palette: aPalette [

	palette := aPalette
]

{ #category : #protocol }
OPPaletteTool >> select [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPPaletteTool >> selectedControllers: aCollectionOfControllers [

	^ self subclassResponsibility
]

{ #category : #accessing }
OPPaletteTool >> workbench [
	^ palette workbench
]
