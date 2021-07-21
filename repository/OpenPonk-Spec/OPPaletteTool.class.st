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
	"nothing to do here"
]

{ #category : #accessing }
OPPaletteTool >> diagramController [
	^ palette diagramController
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
	^ self subclassResponsibility
]

{ #category : #accessing }
OPPaletteTool >> workbench [
	^ palette workbench
]
