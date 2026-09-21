"
Controller managing OPNote diagram elements. 
Operates as a diagram-only controller (having no underlying structural domain model) and provides user interactions such as resizing for visual note shapes.
"
Class {
	#name : 'OPNoteController',
	#superclass : 'OPDiagramOnlyController',
	#traits : 'OPTResizableFigureController',
	#classTraits : 'OPTResizableFigureController classTrait',
	#category : 'OpenPonk-Core-DiagramOnlyElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramOnlyElements'
}

{ #category : 'construction' }
OPNoteController class >> diagramElementClass [
	^ OPNote
]

{ #category : 'accessing' }
OPNoteController class >> modelClass [

	^ OPNote
]

{ #category : 'constants' }
OPNoteController class >> paletteItemName [
	^ #note
]

{ #category : 'accessing' }
OPNoteController class >> viewModelClass [

	^ OPNoteViewModel
]
